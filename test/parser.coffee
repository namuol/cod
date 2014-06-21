assert = require 'assert'
fs = require 'fs'
parser = require '../lib/parser'

testParse = (input, expected) ->
  result = parser.parse input
  assert.deepEqual result, expected

describe 'the cod parser', ->
  it 'parses plain old text', ->
    input =
      '''
      Hello, this is some text.
      '''

    expected = {
      "!text": "Hello, this is some text."
    }

    testParse input, expected

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

  it 'allows tags to be "re-opened"', ->
    input =
      '''
      @Rectangle
        @extends Shape
        A four-sided shape with all right angles.
      @Rectangle
        @mixin Scalable
      '''

    expected = {
      "Rectangle": {
        "!text": "A four-sided shape with all right angles.",
        "extends": "Shape",
        "mixin": "Scalable"
      }
    }

    testParse input, expected

  it 'builds an array when mutiple tag-value pairs occur', ->
    input =
      '''
      @test aaa
      @test bbb
      @test ccc
      '''

    expected = {
      "test": ["aaa", "bbb", "ccc"]
    }

    testParse input, expected

  it 'allows for inline-nesting of tags', ->
    input =
      '''
      @test:foo:bar 42
      '''

    expected = {
      "test": {
        "foo": {
          "bar": 42
        }
      }
    }

    testParse input, expected


  it 'allows for mixing of inline-nested and normal nested tags', ->
    input =
      '''
      @test:foo:bar
        @biz 42
      '''

    expected = {
      "test": {
        "foo": {
          "bar": {
            "biz": 42
          }
        }
      }
    }

    testParse input, expected

  it 'allows for mixing of inline-nested and normal nested tags with outdenting', ->
    input =
      '''
      @test:foo:bar
        @biz 42
      @whatever
        @yes
      '''

    expected = {
      "test": {
        "foo": {
          "bar": {
            "biz": 42
          }
        }
      },
      "whatever": {
        "yes": true
      }
    }

    testParse input, expected

  it 'can handle the complex example from the readme', ->
    input =
      '''
      @Rectangle
        A four-sided shape with all right angles.
        @extends Shape
      @Rectangle:method:area
        Get the area of this rectangle.
        @return
          The area of this rectangle.
          @type Number
      @Rectangle:mixin Scalable
      @Rectangle:mixin Movable
      '''

    expected = {
      "Rectangle": {
        "!text": "A four-sided shape with all right angles.",
        "extends": "Shape",
        "method": {
          "area": {
            "!text": "Get the area of this rectangle.",
            "return": {
              "!text": "The area of this rectangle.",
              "type": "Number"
            }
          }
        },
        "mixin": ["Scalable", "Movable"]
      }
    }

    testParse input, expected