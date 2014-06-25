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
    result = parse(extract(buf.toString('utf8'), docBegin, docEnd))
    cb null, JSON.stringify(result, null, (if pretty then 2 else 0)) + '\n'

cod = ->
  if typeof arguments[0] is 'string'
    return processString arguments...

  return processStream arguments...

module.exports = cod
