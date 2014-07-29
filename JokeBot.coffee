getRandom = (arr) ->
  arr[Math.floor(Math.random() * arr.length)]

class fortuneGenerator
  generateFortune: ->
    followMap = require "./openbsd.json"
    starters = require "./openbsd.starters.json"
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
    

module.exports = new fortuneGenerator()
