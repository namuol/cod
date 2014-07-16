assert = require 'assert'
tape = require 'tape'
extract = require '../src/extract'

describe = (item, cb) ->
  it = (capability, {input, expected, docBegin, docEnd}) ->
    docBegin ?= '###'
    docEnd ?= '###'
    tape.test item + ' ' + capability, (t) ->
      result = extract input, docBegin, docEnd
      t.deepEqual result, expected
      t.end()
      return

  cb it

describe 'the cod extractor', (it) ->
  it 'ignores plain old text',
    input:
      '''
      Hello, this is some text.
      '''

    expected: ""

  it 'extracts text inside doc-blocks',
    input:
      '''
      Hello, this is some text.
      ###
      This is some doc text.
      ###
      '''

    expected: 
      """
      This is some doc text.
      """

  it 'intelligently de-indents blocks',
    input:
      '''
      Hello, this is some text.
        ###
        This is some doc text.
          Hello
        test
        ###
      '''

    expected:
      """
      This is some doc text.
        Hello
      test
      """

  it 'handles C-style doc-blocks',
    input:
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

    expected:
      """
      This is some doc text.
        Hello
      test
      """
    
    docBegin: '/**'

    docEnd: '*/'

  it 'handles the example from the readme',
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

    expected:
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

  it 'inserts whitespace on blank lines to match previous indentation level',
    input:
      '''
      ###
      Test
        
        Test

      ###
      '''

    expected:
      """
      Test
        
        Test
        
      """
