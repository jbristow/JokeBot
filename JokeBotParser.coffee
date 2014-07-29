fs = require("fs")

filename = "openbsd"

symbol =
  BEGIN: '--BEGIN--'
  EOJ: '--EOJ--'
  CR: '--CR--'
  TAB: '--TAB--'
  DQUOT: '--DOUBLEQUOTE--'
  QUOT: '--QUOTE--'

Array::contains = (obj) ->
  i = 0
  while i < this.length
    return true  if this[i] is obj
    i++
  false

# Array Remove - By John Resig (MIT Licensed)
Array::remove = (from, to) ->
  rest = @slice((to or from) + 1 or @length)
  @length = (if from < 0 then @length + from else from)
  @push.apply this, rest

fs.readFile "#{filename}.txt", "utf8", (err, data) ->
  return console.log(err)  if err
 
  lines = data.split '\n%\n'
  starters = []
  followMap = {}
  for line in lines
    break if line.length < 1
    line = line.trim()
    line = line.replace /\n/, " #{symbol.CR} "
    line = line.replace /\t/, " #{symbol.TAB} "
    words = line.split /\s/
    if words[words.length-1] is '\n'
      words[words.length-1] = symbol.EOJ
    else 
      words.push symbol.EOJ
    wordA = words[0]
    wordB = words[1]
    token = "#{wordA} #{wordB}"
    starters.push token unless starters.contains token
    words.remove 0,1
    prevWord = token
    for word in words
      followMap[prevWord.toLowerCase()] = [] if followMap[prevWord.toLowerCase()] is undefined or followMap[prevWord.toLowerCase()] is null
      word = "\t" if word is symbol.TAB
      word = "\n" if word is symbol.CR

      if word isnt ""
        followMap[prevWord.toLowerCase()].push word
        wordA = wordB
        wordB = word 
        prevWord = "#{wordA} #{wordB}" 

  fs.writeFile("#{filename}.starters.json",JSON.stringify(data: starters))
  fs.writeFile("#{filename}.json", JSON.stringify followMap, null, 2)

  return


