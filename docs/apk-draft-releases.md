# 手動APKのDraft Release保存

APKは手動実行時だけReleaseモードで生成し、未公開のDraft ReleaseへAPKを直接添付します。APKのActions Artifactは併用しません。Releaseモードと本番配布用署名は別です。既存の開発用署名を維持し、Play Store提出物として扱いません。新しい鍵・Secret・PATは追加しません。

## 取得手順

1. Actionsで対象workflowを手動実行します。PRとpushでは解析・テストだけを実行します。
2. 成功したRunのSummaryにあるDraft Releaseリンクを開きます。リポジトリへの書き込み権限があるアカウントでGitHubへログインしてください。公開リポジトリでもDraftは一般公開されません。
3. DraftのAssetsから`.apk`を直接ダウンロードします。zipの展開は不要です。
4. 本文のコミットSHA・Run URL・attempt・SHA-256を確認してから実機へインストールします。ビルド成功だけでは実機の起動確認成功とは扱いません。

署名が異なるAPKへ更新できない場合は、データと設定を退避してから対応してください。アンインストールで設定は消えます。

## 公開・上書き・保持

保存識別子は`ci-apk-run-<run_id>-attempt-<attempt>`、APK名は`<repo>-ci-release-<sha12>-<run_id>-<attempt>.apk`です。再実行も別のDraftになります。同じ識別子のReleaseやタグがある場合は停止し、置換しません。

APIへ常に`draft: true`、`prerelease: true`、`make_latest: false`を指定します。公開・Discussion作成・自動release notes・タグの作成/pushは行いません。添付後もDraft状態とタグ参照が存在しないことを検証します。失敗時に公開や削除へ進む処理はなく、不完全なDraftが残る場合があります。

Draft作成・編集ではGitHub Actionsのreleaseイベントは起動しません。既存のpush/deploy workflowを起動するタグpushも行いません。実行による公開通知を意図する処理はありません。人がPublishすると別の副作用が発生するため、このAPKをPublishしないでください。

Draft Releaseの添付にはActions Artifactの保持3日は適用されません。別途削除するまで保持されます。この変更は既存Artifact・cacheの削除や移動、自動清掃を行いません。iOS Artifact・coverage・Actions cacheの設定は従来どおりです。

## 権限と実機確認の制約

既存workflowの`contents: write`を使用し、権限設定は変更していません。

さらに、PRの対象SHAで`.github/workflows/`がdefault branchと異なる間は、Release作成にWorkflows:writeが必要です。標準`GITHUB_TOKEN`には付与できないため、未マージPR headからの手動ビルド・添付のE2E検証は停止します。保存処理は事前チェックで拒否し、別SHAへの差し替えはしません。新しいPAT/Secretを追加して回避しません。人によるレビュー・マージ後、必要なContents権限が承認された状態で手動検証してください。このPR自身はマージ・公開を行いません。

自動CIでは`python3 -m unittest discover -s .github/scripts -p "test_*.py"`で保存処理を外部書き込みなしに検証します。実際のAPK添付はE2E未実行であり、単体テストの成功と区別します。

根拠: [Release APIと権限](https://docs.github.com/en/rest/releases/releases#create-a-release)、[Draftのイベント制約](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#release)、[Releaseの容量制限](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)。

このリポジトリは`CI`を手動実行します。既存の`ciDeviceApk=true`による開発用署名の指定を維持します。
