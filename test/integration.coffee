assert = require 'assert'
fs = require 'fs'
cod = require '../src/index'

test = (input, expected, openPat='###', closePat='###') ->
  result = cod input,
    open: openPat
    close: closePat
  assert.deepEqual result, expected

describe 'cod', ->
  it 'ignores plain old text', ->
    input =
      '''
      Hello, this is some text.
      '''

    expected = {}

    test input, expected

  it 'can handle the example from the readme', ->
    input =
      '''
      ###
      @Rectangle
        A four-sided shape with all right angles.

        @extends Shape
      ###
      class Rectangle extends Shape
        ###
        @Rectangle:method:area
          Get the area of this rectangle.
          @return
            The area of this rectangle.
            @type Number
        ###
        area: -> return @width * @height
        
      ###
      @Rectangle:mixin Scalable
      ###
      mixin(Rectangle, Scalable)

      ###
      @Rectangle:mixin Movable
      ###
      mixin(Rectangle, Movable)
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
        "mixin": [
          "Scalable",
          "Movable"
        ]
      }
    }

    test input, expected
