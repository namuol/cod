module.exports = (text, openPat, closePat) ->
  result = []
  depth = 0
  inside = false

  for line in text.split '\n'
    if !inside
      depth = line.indexOf openPat
      if depth >= 0
        inside = true
    else
      idx = line.indexOf closePat
      if idx >= 0
        inside = false
      else
        substr = line.substr depth
        if substr.trim().length > 0
          result.push substr

  return result.join '\n'
