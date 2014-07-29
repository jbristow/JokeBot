express = require "express"
bodyParser = require "body-parser"
app = express()
fortune = require("./JokeBot")
secrets = require "./secrets"

onSuccess = (res) ->
  res.jsonp 200,
    text: fortune.generateFortune()
  
onFail = (res) ->
  res.jsonp 500,
    error: "Internal Server Error"

requestHandlerGet = (req, res) ->
  if req.query.token is secrets.token
    onSuccess(res)
  else
    onFail(res)
  return

requestHandlerPost = (req, res) ->
  if req.body.token is secrets.token
    onSuccess(res)
  else
    onFail(res)
  return

# parse application/x-www-form-urlencoded
app.use bodyParser.urlencoded(extended: false)

# parse application/json
app.use bodyParser.json()

app.get "/fortune-gen", requestHandlerGet
app.post "/fortune-gen", requestHandlerPost
app.listen 1337

console.log "Server running at http://127.0.0.1:1337/"
