assert = require 'assert'
fs = require 'fs'
extract = require '../src/extract'

textExtract = (input, expected, openPat='###', closePat='###') ->
  result = extract input, openPat, closePat
  assert.deepEqual result, expected

describe 'the cod extractor', ->
  it 'ignores plain old text', ->
    input =
      '''
      Hello, this is some text.
      '''

    expected = ""

    textExtract input, expected

  it 'extracts text inside doc-blocks', ->
    input =
      '''
      Hello, this is some text.
      ###
      This is some doc text.
      ###
      '''

    expected = 
      """
      This is some doc text.
      """

    textExtract input, expected


  it 'intelligently de-indents blocks', ->
    input =
      '''
      Hello, this is some text.
        ###
        This is some doc text.
          Hello
        test
        ###
      '''

    expected =
      """
      This is some doc text.
        Hello
      test
      """

    textExtract input, expected

  it 'handles C-style doc-blocks', ->
    input =
      '''
      Hello, this is some text.
        /**
        This is some doc text.
          Hello
        test
        */
        /*
        This is a normal comment
        */
      '''

    expected =
      """
      This is some doc text.
        Hello
      test
      """

    textExtract input, expected, '/**', '*/'

  it 'handles the example from the readme', ->
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

    expected =
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

    textExtract input, expected
