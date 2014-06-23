parse = require('../lib/parser').parse
extract = require './extract'

module.exports = (text, {docBegin, docEnd}={}) ->
  docBegin ?= '/**'
  docEnd ?= '*/'
  return parse extract text, docBegin, docEnd