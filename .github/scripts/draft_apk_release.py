"""Store one manual CI APK in a new unpublished release; never push tags."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import urllib.error
import urllib.parse
import urllib.request


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise RuntimeError("Unexpected API redirect; refusing to forward credentials")


class GitHub:
    def __init__(self, token):
        self.token = token
        self.opener = urllib.request.build_opener(NoRedirect)

    def request(self, method, path, *, payload=None, file=None, missing_ok=False):
        url = path if path.startswith("https://") else "https://api.github.com" + path
        parsed = urllib.parse.urlsplit(url)
        if parsed.scheme != "https" or parsed.hostname not in ("api.github.com", "uploads.github.com"):
            raise RuntimeError("Unexpected GitHub API host")
        headers = {"Authorization": "Bearer " + self.token,
                   "Accept": "application/vnd.github+json", "X-GitHub-Api-Version": "2022-11-28"}
        data = json.dumps(payload).encode() if payload is not None else None
        if file is not None:
            headers.update({"Content-Type": "application/vnd.android.package-archive",
                            "Content-Length": str(file.stat().st_size)})
            data = file.open("rb")
        elif data is not None:
            headers["Content-Type"] = "application/json"
        try:
            request = urllib.request.Request(url, data=data, headers=headers, method=method)
            with self.opener.open(request, timeout=120) as response:
                return json.load(response)
        except urllib.error.HTTPError as error:
            if missing_ok and error.code == 404:
                return None
            raise RuntimeError(f"GitHub API HTTP {error.code}; check token permissions and release policy") from None
        finally:
            if file is not None:
                data.close()


def context(env):
    if env.get("GITHUB_EVENT_NAME") != "workflow_dispatch" or env.get("GITHUB_ACTIONS") != "true":
        raise RuntimeError("Draft APK storage is allowed only from manual GitHub Actions runs")
    repo, sha = env.get("GITHUB_REPOSITORY", ""), env.get("GITHUB_SHA", "")
    run, attempt = env.get("GITHUB_RUN_ID", ""), env.get("GITHUB_RUN_ATTEMPT", "")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repo):
        raise RuntimeError("Invalid repository")
    if not re.fullmatch(r"[0-9a-f]{40,64}", sha) or not run.isdigit() or not attempt.isdigit():
        raise RuntimeError("Invalid source SHA or run identity")
    return dict(repo=repo, sha=sha, run=run, attempt=attempt,
                tag=f"ci-apk-run-{run}-attempt-{attempt}")


def preflight(client, ctx):
    prefix = "/repos/" + ctx["repo"]
    repo = client.request("GET", prefix)
    branch = urllib.parse.quote(repo["default_branch"], safe="")
    default_sha = client.request("GET", prefix + "/commits/" + branch)["sha"]
    def workflows(ref):
        entries = client.request("GET", prefix + "/contents/.github/workflows?ref=" + ref)
        return {e["path"]: e["sha"] for e in entries}
    if workflows(default_sha) != workflows(ctx["sha"]):
        raise RuntimeError("Source workflows differ from the default branch. Creating a release for this SHA requires Workflows:write, which GITHUB_TOKEN cannot receive. Stop; do not substitute another target SHA or add a PAT.")
    tag_path = prefix + "/git/ref/tags/" + ctx["tag"]
    if client.request("GET", tag_path, missing_ok=True) is not None:
        raise RuntimeError("Reserved tag already exists; refusing to reuse it")
    for page in range(1, 1001):
        releases = client.request("GET", prefix + f"/releases?per_page=100&page={page}")
        if any(r["tag_name"] == ctx["tag"] for r in releases):
            raise RuntimeError("Release identity already exists; no overwrite or asset replacement is allowed")
        if len(releases) < 100:
            return repo
    raise RuntimeError("Could not establish a collision-free release identity")


def require_draft(release, ctx):
    if (release.get("draft") is not True or release.get("published_at") is not None
            or release.get("tag_name") != ctx["tag"] or release.get("target_commitish") != ctx["sha"]):
        raise RuntimeError("Release is not the expected unpublished draft for the exact source SHA")


def publish(client, ctx, apk):
    preflight(client, ctx)
    if apk.is_symlink() or not apk.is_file() or apk.suffix != ".apk" or not 0 < apk.stat().st_size < 2 * 1024**3:
        raise RuntimeError("Expected a nonempty regular APK smaller than 2 GiB")
    with apk.open("rb") as stream:
        digest = hashlib.file_digest(stream, "sha256").hexdigest()
    name = f"{ctx['repo'].split('/')[1]}-ci-release-{ctx['sha'][:12]}-{ctx['run']}-{ctx['attempt']}.apk"
    prefix = "/repos/" + ctx["repo"]
    body = ("Manual CI device-check Release APK. Not a store distribution.\n\n"
            f"Source commit: {ctx['sha']}\n"
            f"Run: https://github.com/{ctx['repo']}/actions/runs/{ctx['run']} (attempt {ctx['attempt']})\n"
            f"Asset: {name}\nSHA-256: {digest}\n\n"
            "Keep this release as a draft. Do not publish it or create/push its tag.\n")
    release = client.request("POST", prefix + "/releases", payload={
        "tag_name": ctx["tag"], "target_commitish": ctx["sha"],
        "name": f"CI device APK {ctx['sha'][:12]} / {ctx['run']}-{ctx['attempt']}",
        "body": body, "draft": True, "prerelease": True,
        "make_latest": "false", "generate_release_notes": False})
    require_draft(release, ctx)
    if client.request("GET", prefix + "/git/ref/tags/" + ctx["tag"], missing_ok=True) is not None:
        raise RuntimeError("Unexpected tag ref; stopping without further changes")
    upload = release["upload_url"].split("{")[0]
    parsed = urllib.parse.urlsplit(upload)
    if parsed.scheme != "https" or parsed.hostname != "uploads.github.com" or parsed.path != prefix + f"/releases/{release['id']}/assets":
        raise RuntimeError("Unexpected asset upload endpoint")
    asset = client.request("POST", upload + "?name=" + urllib.parse.quote(name, safe=""), file=apk)
    if (asset.get("state") != "uploaded" or asset.get("name") != name or asset.get("size") != apk.stat().st_size
            or (asset.get("digest") and asset["digest"] != "sha256:" + digest)):
        raise RuntimeError("Uploaded APK metadata or digest did not verify; draft was not published")
    checked = client.request("GET", prefix + f"/releases/{release['id']}")
    require_draft(checked, ctx)
    if client.request("GET", prefix + "/git/ref/tags/" + ctx["tag"], missing_ok=True) is not None:
        raise RuntimeError("Unexpected tag ref after upload; stopping without further changes")
    return dict(release_id=release["id"], release_url=release["html_url"], asset_id=asset["id"],
                asset_name=name, sha256=digest, tag_ref_created=False, draft=True)


def main():
    args = argparse.ArgumentParser()
    args.add_argument("--check", action="store_true")
    args.add_argument("--contents-write-pending", action="store_true")
    args.add_argument("--apk", type=Path, default=Path("build/app/outputs/flutter-apk/app-release.apk"))
    options = args.parse_args()
    if options.contents_write_pending:
        raise RuntimeError("BLOCKED: manual APK job Contents:write has not been approved. Keep permissions unchanged and stop before building.")
    ctx = context(os.environ)
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise RuntimeError("GITHUB_TOKEN is required; do not register a new secret or PAT")
    client = GitHub(token)
    if options.check:
        preflight(client, ctx)
        print("Preflight passed. Release creation/upload additionally requires existing Contents:write.")
        return
    result = publish(client, ctx, options.apk)
    print(json.dumps(result))
    if os.environ.get("GITHUB_STEP_SUMMARY"):
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as summary:
            summary.write(f"\nAPK stored in an unpublished [Draft Release]({result['release_url']}).\n\n"
                          f"Source `{ctx['sha']}`; asset `{result['asset_name']}`; SHA-256 `{result['sha256']}`.\n"
                          "Drafts require repository write access to view. No APK Actions Artifact was uploaded.\n")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError) as error:
        print(f"::error::{error}", file=sys.stderr)
        raise SystemExit(1)
