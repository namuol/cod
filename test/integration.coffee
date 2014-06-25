tape = require 'tape'
cod = require '../lib/index'

normalize = (o) -> JSON.stringify(JSON.parse(JSON.stringify(o)))

describe = (item, cb) ->
  it = (capability, {input, expected, docBegin, docEnd}) ->
    docBegin ?= '###'
    docEnd ?= '###'

    tape.test item + ' ' + capability, (t) ->
      result = result = cod input,
        docBegin: docBegin
        docEnd: docEnd
      t.deepEqual result, expected
      t.end()
      return

  cb it

describe 'cod', (it) ->
  it 'ignores plain old text',
    input:
      '''
      Hello, this is some text.
      '''

    expected: {}

  it 'can handle the example from the readme',
    input:
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

    expected: {
      "Rectangle": {
        "!text": "A four-sided shape with all right angles.\n",
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
