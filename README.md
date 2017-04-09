# github-wiki-bot

## heroku の設定

### herokuアプリを作成
```
% heroku create my-app-name
```

### redisを利用するのでアドオンをインストール
```
% heroku addons:add redistogo:nano
```

### 環境変数を設定
```
% heroku config:add HUBOT_GITHUB_SECRET="github webhook secret"
% heroku config:add HUBOT_HEROKU_KEEPALIVE_URL="heroku app url"
% heroku config:add HUBOT_SLACK_TOKEN="slack token"
% heroku config:add ROOM_NAME="my room name"
```

### デプロイ
```
% git push heroku master
```

## github の設定
### Webhook を登録する
- Settings -> Webhooks -> Add webhook

### 各項目を入力
- Payload URL -> https://my-app-name.herokuapp.com/github/wiki
- Content type -> `application/json`
- Secret -> herokuで設定した `HUBOT_GITHUB_SECRET` と同じものを指定
- Which events would you like to trigger this webhook? ->
`Let me select individual events.` を選択して `Gollum` にチェックを入れる(Pushは外してOK)
- Active -> checked

### Add webhook をクリックして登録完了
