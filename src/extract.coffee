module.exports = (text, beginDoc, endDoc) ->
  result = []
  depth = 0
  subdepth = 0
  inside = false

  for line in text.split '\n'
    if !inside
      depth = line.indexOf beginDoc
      if depth >= 0
        inside = true
    else
      idx = line.indexOf endDoc
      if idx >= 0
        inside = false
      else
        substr = line.substr depth
        search = substr.search /[^ ]/
        if search >= 0
          subdepth = search
        else if substr.length < subdepth
          # HACK:
          # Correct blank lines' whitespace to match
          #  the previous indentation level.
          substr = (new Array(subdepth + 1)).join(' ')
        result.push substr

  return result.join '\n'
