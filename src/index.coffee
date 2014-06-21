parse = require('../lib/parser').parse
extract = require './extract'

module.exports = (text, {open, close}) ->
  open ?= '###'
  close ?= '###'
  return parse extract text, open, close