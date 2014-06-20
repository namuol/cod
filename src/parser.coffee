###
Adapted from http://stackoverflow.com/a/10708913/742156
###

isArray = (obj) ->
  Object::toString.call(obj) is '[object Array]'

build = (first, tail) ->
  list = start(first, tail)
  keyStack = []
  doc = {}
  obj = doc
  len = list.length
  
  doIndent = (key) ->
    if obj[key] is true
      obj[key] = {}
    obj = obj[key]

  for item in list
    continue  unless item? # Blank lines are undefined
    switch item.type
      when 'tag'
        key = item.name
        unless obj[key]?
          obj[key] = item.value or true
        else
          if typeof obj[key] is 'string'
            obj[key] = [obj[key]]
          if isArray obj[key]
            obj[key].push item.value or true

      when 'indent'
        key = prev.name
        doIndent(key)
        keyStack.push key

      when 'outdent'
        keyStack.pop()
        obj = doc
        for key in keyStack
          obj = obj[key]

      when 'text'
        if item.text
          obj['!text'] = item.text

    prev = item

  return doc

start = (first, tail) ->
  done = [first[1]]
  i = 0
  while i < tail.length
    done = done.concat tail[i][1][0]
    done.push tail[i][1][1]
    i += 1
  return done

depths = [0]

indent = (s) ->
  depth = s.length
  return []  if depth is depths[0]

  if depth > depths[0]
    depths.unshift depth
    return [type: 'indent']

  dents = []

  while depth < depths[0]
    depths.shift()
    dents.push type: 'outdent'

  dents.push type: 'baddent'  unless depth is depths[0]

  return dents
