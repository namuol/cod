###
Adapted from http://stackoverflow.com/a/10708913/742156
###

lvl = 0
prev = {}

isArray = (obj) ->
  Object::toString.call(obj) is '[object Array]'

primitiveTypes = ['string', 'boolean', 'number']

isPrimitive = (obj) -> (typeof obj) in primitiveTypes

extractObj = (obj) ->
  if isArray obj
    _obj = obj[obj.length-1]
  else
    _obj = obj

  if isPrimitive _obj
    if not isArray obj
      throw new Error 'Expected a list but got a primitive'
    newObj = Object.create null
    newObj['!value'] = _obj
    _obj = obj[obj.length-1] = newObj

  return _obj

build = (list) ->
  keyStack = []
  doc = Object.create null
  obj = doc
  len = list.length

  doIndent = (key) ->
    if isArray obj
      _obj = obj[obj.length-1]
    else
      _obj = obj

    val = _obj[key]
    if (not val?) or isPrimitive(val)
      _obj[key] = Object.create null
      if val? and val isnt true
        _obj[key]['!value'] = val
    obj = _obj[key]

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

        _obj = extractObj obj

        if not _obj[key]?
          _obj[key] = item.value ? true
        else
          if (not item.value? or isPrimitive(item.value)) and not isArray _obj[key]
            _obj[key] = [_obj[key]]

          if isArray _obj[key]
            if item.value?
              value = item.value
            else
              value = Object.create null
              newObj = value
            _obj[key].push value

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
            if isArray obj
              obj = obj[obj.length-1]
            obj = obj[key]

      when 'text'
        item.text ?= ''
        
        _obj = extractObj obj

        if _obj['!text']?
          _obj['!text'] += '\n' + item.text
        else
          _obj['!text'] = item.text

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
