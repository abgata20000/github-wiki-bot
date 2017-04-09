# GitHubから来たWiki通知をSlackに飛ばす
#
crypto = require 'crypto'
roomName = process.env['ROOM_NAME'] || 'general'

module.exports = (robot) ->
  robot.router.post "/github/wiki", (req, res) ->
    event_type = req.get 'X-Github-Event'
    signature = req.get 'X-Hub-Signature'

    unless isCorrectSignature signature, req.body
      res.status(401).send 'unauthorized'
      return

    switch event_type
      when 'gollum'
        message = atWiki req.body
        robot.messageRoom roomName, message

    res.status(200).send 'ok'

  atWiki = (body) ->
    switch body.pages[0].action
      when 'edited'
        messages = []
        messages.push "***** GitHub Wiki Updated ******"
        messages.push "Title: " + body.pages[0].page_name
        messages.push "Sender: " + body.sender.login
        messages.push "Page: " + body.pages[0].html_url
        messages.push "Difference: " + differenceUrl(body)
        message = messages.join("\n")
        return message

  differenceUrl = (body) ->
    body.pages[0].html_url + '/_compare/' + body.pages[0].sha

  isCorrectSignature = (signature, body) ->
    pairs = signature.split '='
    digest_method = pairs[0]
    hmac = crypto.createHmac digest_method, process.env['HUBOT_GITHUB_SECRET']
    hmac.update JSON.stringify(body), 'utf-8'
    hashed_data = hmac.digest 'hex'
    generated_signature = [digest_method, hashed_data].join '='
    return signature is generated_signature
