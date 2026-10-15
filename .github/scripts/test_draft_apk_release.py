import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest import mock
import urllib.parse

import draft_apk_release as subject


ENV = dict(GITHUB_ACTIONS="true", GITHUB_EVENT_NAME="workflow_dispatch",
           GITHUB_REPOSITORY="owner/app", GITHUB_SHA="a" * 40,
           GITHUB_RUN_ID="123", GITHUB_RUN_ATTEMPT="1")


class FakeGitHub:
    def __init__(self):
        self.calls = []
        self.workflow_change = False
        self.tag_exists = False
        self.release_collision = False
        self.second_page = False
        self.published = False
        self.bad_upload_host = False
        self.bad_digest = False

    def request(self, method, path, *, payload=None, file=None, missing_ok=False):
        self.calls.append((method, path, payload))
        if method == "GET" and path == "/repos/owner/app":
            return dict(default_branch="main", private=True)
        if "/commits/" in path:
            return dict(sha="b" * 40)
        if "/contents/.github/workflows?ref=" in path:
            changed = self.workflow_change and path.endswith("a" * 40)
            return [dict(path=".github/workflows/ci.yml", sha="changed" if changed else "same")]
        if "/git/ref/tags/" in path:
            return dict(ref="refs/tags/existing") if self.tag_exists else None
        if "/releases?" in path:
            if self.second_page and path.endswith("page=1"):
                return [dict(tag_name=f"other-{i}") for i in range(100)]
            return [dict(tag_name="ci-apk-run-123-attempt-1")] if self.release_collision else []
        if method == "POST" and path == "/repos/owner/app/releases":
            self.release = dict(payload, id=7, published_at=None,
                                html_url="https://github.com/owner/app/releases/tag/untagged-seven",
                                upload_url="https://uploads.github.com/repos/owner/app/releases/7/assets{?name,label}")
            if self.published:
                self.release.update(draft=False, published_at="2026-01-01T00:00:00Z")
            if self.bad_upload_host:
                self.release["upload_url"] = "https://example.invalid/upload{?name}"
            return self.release
        if method == "POST" and path.startswith("https://uploads.github.com/"):
            name = urllib.parse.parse_qs(urllib.parse.urlsplit(path).query)["name"][0]
            digest = hashlib.sha256(file.read_bytes()).hexdigest()
            return dict(id=8, state="uploaded", name=name, size=file.stat().st_size,
                        digest="sha256:" + ("0" * 64 if self.bad_digest else digest))
        if method == "GET" and path == "/repos/owner/app/releases/7":
            return self.release
        raise AssertionError((method, path))


class DraftReleaseTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.apk = Path(self.tmp.name) / "app-release.apk"
        self.apk.write_bytes(b"test APK content")
        self.ctx = subject.context(ENV)
        self.api = FakeGitHub()

    def assert_no_writes(self):
        self.assertTrue(all(method == "GET" for method, _, _ in self.api.calls))

    def test_success_is_a_new_exact_sha_unpublished_release_only(self):
        result = subject.publish(self.api, self.ctx, self.apk)
        posts = [(path, payload) for method, path, payload in self.api.calls if method == "POST"]
        self.assertEqual(len(posts), 2)
        payload = posts[0][1]
        self.assertIs(payload["draft"], True)
        self.assertIs(payload["prerelease"], True)
        self.assertIs(payload["generate_release_notes"], False)
        self.assertEqual(payload["make_latest"], "false")
        self.assertEqual(payload["target_commitish"], ENV["GITHUB_SHA"])
        self.assertEqual(payload["tag_name"], "ci-apk-run-123-attempt-1")
        self.assertIn(result["sha256"], payload["body"])
        self.assertNotIn("@", payload["body"])
        self.assertNotIn("discussion_category_name", payload)
        self.assertFalse(result["tag_ref_created"])
        self.assertTrue(all(method in ("GET", "POST") for method, _, _ in self.api.calls))
        self.assertTrue(all("/git/refs" not in path for _, path, _ in self.api.calls))

    def test_pending_contents_permission_stops_before_api_or_build(self):
        with mock.patch("sys.argv", ["draft_apk_release.py", "--check", "--contents-write-pending"]):
            with self.assertRaisesRegex(RuntimeError, "Contents:write has not been approved"):
                subject.main()

    def test_automatic_or_local_invocations_cannot_write(self):
        for changes in (dict(GITHUB_EVENT_NAME="push"), dict(GITHUB_EVENT_NAME="pull_request"), dict(GITHUB_ACTIONS="false")):
            with self.assertRaisesRegex(RuntimeError, "manual"):
                subject.context(dict(ENV, **changes))

    def test_workflow_change_blocks_without_substituting_target_sha(self):
        self.api.workflow_change = True
        with self.assertRaisesRegex(RuntimeError, "Workflows:write"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assert_no_writes()

    def test_existing_tag_never_reused(self):
        self.api.tag_exists = True
        with self.assertRaisesRegex(RuntimeError, "tag already exists"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assert_no_writes()

    def test_existing_draft_on_later_page_never_overwritten(self):
        self.api.release_collision = self.api.second_page = True
        with self.assertRaisesRegex(RuntimeError, "no overwrite"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assert_no_writes()

    def test_attempt_number_provides_new_identity(self):
        other = subject.context(dict(ENV, GITHUB_RUN_ATTEMPT="2"))
        self.assertNotEqual(self.ctx["tag"], other["tag"])
        self.assertEqual(other["sha"], self.ctx["sha"])

    def test_missing_or_empty_apk_does_not_create_release(self):
        for content in (None, b""):
            if self.apk.exists(): self.apk.unlink()
            if content is not None: self.apk.write_bytes(content)
            with self.assertRaisesRegex(RuntimeError, "regular APK"):
                subject.publish(self.api, self.ctx, self.apk)
            self.assert_no_writes()

    def test_published_response_is_rejected_before_upload(self):
        self.api.published = True
        with self.assertRaisesRegex(RuntimeError, "unpublished draft"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assertEqual(sum(method == "POST" for method, _, _ in self.api.calls), 1)

    def test_foreign_upload_host_never_receives_credentials(self):
        self.api.bad_upload_host = True
        with self.assertRaisesRegex(RuntimeError, "upload endpoint"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assertFalse(any("example.invalid" in path for _, path, _ in self.api.calls))

    def test_digest_mismatch_never_publishes_or_deletes(self):
        self.api.bad_digest = True
        with self.assertRaisesRegex(RuntimeError, "digest did not verify"):
            subject.publish(self.api, self.ctx, self.apk)
        self.assertTrue(all(method in ("GET", "POST") for method, _, _ in self.api.calls))


if __name__ == "__main__":
    unittest.main()
