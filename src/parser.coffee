###
Adapted from http://stackoverflow.com/a/10708913/742156
###

lvl = 0
prev = {}

isArray = (obj) ->
  Object::toString.call(obj) is '[object Array]'

build = (list) ->
  keyStack = []
  doc = Object.create null
  obj = doc
  len = list.length

  # console.log list

  doIndent = (key) ->
    if (not obj[key]?) or obj[key] is true
      obj[key] = Object.create null
    obj = obj[key]

  # HACK: edge-case where we essentially have an empty body:
  if (list.length is 1) and (list[0].type is 'text') and (not list[0].text?)
    return Object.create null

  for item in list
    switch item.type
      when 'tag'
        newObj = null

        keys = item.name.split ':'
        
        prevObj = obj # HACKish
        
        for key in keys[...-1]
          doIndent key

        key = keys[keys.length-1]
        if not obj[key]?
          obj[key] = item.value or true
        else
          if (not item.value? or (typeof item.value is 'string')) and not isArray obj[key]
            obj[key] = [obj[key]]

          if isArray obj[key]
            if item.value?
              value = item.value
            else
              value = Object.create null
              newObj = value
            newObjIdx = obj[key].push value
        
        obj = prevObj # HACKish
        prev = item

      when 'indent'
        continue  if not prev?.name?
        for key in prev.name.split ':'
          doIndent(key)
        keyStack.push prev.name

      when 'outdent'
        keyStack.pop()
        obj = doc
        for name in keyStack
          for key in name.split(':')
            obj = obj[key]

      when 'text'
        item.text ?= ''
        newObj ?= obj
        if newObj['!text']?
          newObj['!text'] += '\n' + item.text
        else
          if typeof newObj is 'string'
            _newObj = Object.create null
            _newObj['!value'] = newObj
            newObj = _newObj
            prevObj[key] = newObj
          newObj['!text'] = item.text

  return doc

depths = [0]

indent = (s) ->
  depth = s.length
  return []  if depth is depths[0]

  if depth > depths[0]
    depths.unshift depth
    return [type: 'indent', depth: depth]

  dents = []

  while depth < depths[0]
    depths.shift()
    dents.push type: 'outdent', depth: depth

  unless depth is depths[0]
    dents.push type: 'baddent'

  return dents
