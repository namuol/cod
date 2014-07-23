parse = require('./parser').parse
extract = require './extract'

defaults =
  docBegin: '/**'
  docEnd: '*/'
  pretty: true

processString = (text, {docBegin, docEnd}=defaults) ->
  docBegin ?= defaults.docBegin
  docEnd ?= defaults.docEnd

  return parse extract text, docBegin, docEnd

processStream = ({docBegin, docEnd, pretty}=defaults) ->
  BufferStreams = require 'bufferstreams'

  docBegin ?= defaults.docBegin
  docEnd ?= defaults.docEnd
  pretty ?= true

  return new BufferStreams (err, buf, cb) ->
    throw err  if err
    str = extract(buf.toString('utf8'), docBegin, docEnd)
    try
      result = parse str
    catch e
      spl = str.split('\n')
      e.message = e.message + '\n----\n    ' + spl[e.line-3..e.line-2].join('\n    ') + '\n--->' + spl[e.line-1] + '\n    ' + spl[e.line..e.line+2].join('\n    ') + '\n----'
      console.error '\n' + e.message + '\n'
      throw e
    cb null, JSON.stringify(result, null, (if pretty then 2 else 0)) + '\n'

cod = ->
  if arguments[0] instanceof Buffer
    arguments[0] = arguments[0].toString 'utf8'
  
  if typeof arguments[0] is 'string'
    return processString arguments...

  return processStream arguments...

module.exports = cod
