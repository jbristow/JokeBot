fs = require "fs"

getRandom = (arr) ->
  arr[Math.floor(Math.random() * arr.length)]


class fortuneGenerator
  constructor: (@filename) ->

  generateFortune: ->
    followMap = JSON.parse(fs.readFileSync("#{@filename}.json", 'utf8')); 
    starters = JSON.parse(fs.readFileSync("#{@filename}.starters.json", 'utf8')); 
    output = ""
    prevPair= getRandom(starters.data)
    current = prevPair.split(" ")[1]
    prevWord = prevPair.split(" ")[0]
    while current isnt "--EOJ--"
      output = @handleOutput output, prevWord
      prevWord = current
      current = getRandom followMap["#{prevPair.toLowerCase()}"]
      prevPair = "#{prevWord} #{current}"
    output = @handleOutput output, prevWord

    return output

  handleOutput: (prev, current) ->
    out = ""
    if prev is ""
      out = "#{current}"
    else if current.match /^\s+$/
      out = "#{prev}#{current}"
    else
      out = "#{prev} #{current}"
    out

module.exports = new fortuneGenerator("openbsd")
