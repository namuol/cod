module.exports = (text, openPat='###', closePat='###') ->
  result = []
  depth = 0
  inside = false
  for line in text.split '\n'
    if !inside
      depth = line.indexOf openPat
      if depth >= 0
        inside = true
        continue
    else
      idx = line.indexOf closePat
      if idx >= 0
        inside = false
      else
        result.push line.substr depth
  return result.join '\n'
