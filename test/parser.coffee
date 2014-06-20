assert = require 'assert'
fs = require 'fs'
parser = require '../lib/parser'

testParse = (input, expected) ->
  result = parser.parse input
  assert.deepEqual result, expected

describe 'the cod parser', ->
  it 'parses a single tag', ->
    input =
      '''
      @Rectangle
      '''

    expected = {
      "Rectangle": true
    }

    testParse input, expected

  it 'parses a nested tag', ->
    input =
      '''
      @Rectangle
        @extends Shape
      '''

    expected = {
      "Rectangle": {
        "extends": "Shape"
      }
    }

    testParse input, expected

  it 'parses nested text', ->
    input =
      '''
      @Rectangle
        @extends Shape
        A four-sided shape with all right angles.
      '''

    expected = {
      "Rectangle": {
        "!text": "A four-sided shape with all right angles.",
        "extends": "Shape"
      }
    }

    testParse input, expected

  it 'parses multiple outdented tags', ->
    input =
      '''
      @foo
        @test
          @biz
        @baz
      @bar
        @test
      '''

    expected = {
      "foo": {
        "test": {
          "biz": true
        },
        "baz": true
      },
      "bar": {
        "test": true
      }
    }

    testParse input, expected

  # it 'parses inline-nested tags', ->
  #   input =
  #     '''
  #     @Rectangle
  #       @extends Shape
  #       A four-sided shape with all right angles.

  #     @Rectangle:mixin Scalable
  #     '''

  #   expected = {
  #     "Rectangle": {
  #       "!text": "A four-sided shape with all right angles.",
  #       "extends": "Shape",
  #       "mixin": "Scalable"
  #     }
  #   }

  #   testParse input, expected

