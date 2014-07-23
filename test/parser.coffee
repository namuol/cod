assert = require 'assert'
tape = require 'tape'
parser = require '../lib/parser'

normalize = (o) -> JSON.stringify(o, null, 2)

describe = (item, cb) ->
  it = (capability, {input, expected}) ->
    tape.test item + ' ' + capability, (t) ->
      result = parser.parse input
      t.deepEqual result, expected
      t.end()
      return

  cb it

describe 'the cod parser', (it) ->
  it 'parses plain old text',
    input:
      '''
      Hello, this is some text.
      '''

    expected: {
      "!text": "Hello, this is some text."
    }

  it 'parses a single tag',
    input:
      '''
      @Rectangle
      '''

    expected: {
      "Rectangle": true
    }
  
  it 'parses integers',
    input:
      '''
      @value 42
      '''

    expected: {
      "value": 42
    }

  it 'parses floats',
    input:
      '''
      @value 42.5
      '''

    expected: {
      "value": 42.5
    }

  it 'parses booleans',
    input:
      '''
      @shouldBeTrue true
      @shouldBeFalse false
      '''

    expected: {
      "shouldBeTrue": true
      "shouldBeFalse": false
    }

  it 'parses a nested tag',
    input:
      '''
      @Rectangle
        @extends Shape
      '''

    expected: {
      "Rectangle": {
        "extends": "Shape"
      }
    }

  it 'parses nested text',
    input:
      '''
      @Rectangle
        @extends Shape
        A four-sided shape with all right angles.
      '''

    expected: {
      "Rectangle": {
        "extends": "Shape",
        "!text": "A four-sided shape with all right angles."
      }
    }

  it 'parses multiple outdented tags',
    input:
      '''
      @foo
        @test
          @biz
        @baz
      @bar
        @test
      '''

    expected: {
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

  it 'allows tags to be "re-opened"',
    input:
      '''
      @Rectangle
        @extends Shape
        A four-sided shape with all right angles.
      @Rectangle:mixin Scalable
      '''

    expected: {
      "Rectangle": {
        "extends": "Shape",
        "!text": "A four-sided shape with all right angles.",
        "mixin": "Scalable"
      }
    }

  it 'builds an array when mutiple tag-value pairs occur',
    input:
      '''
      @test aaa
      @test bbb
      @test ccc
      '''

    expected: {
      "test": ["aaa", "bbb", "ccc"]
    }

  it 'allows for inline-nesting of tags',
    input:
      '''
      @test:foo:bar 42
      '''

    expected: {
      "test": {
        "foo": {
          "bar": 42
        }
      }
    }

  it 'allows for mixing of inline-nested and normal nested tags',
    input:
      '''
      @test:foo:bar
        @biz 42
      '''

    expected: {
      "test": {
        "foo": {
          "bar": {
            "biz": 42
          }
        }
      }
    }

  it 'allows for mixing of inline-nested and normal nested tags with outdenting',
    input:
      '''
      @test:foo:bar
        @biz 42
      @whatever
        @yes
      '''

    expected: {
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

  it 'preserves vertical whitespace in text blocks',
    input:
      '''
      This is some multiline
      text.


      Newlines are preserved.



      Really!
      '''

    expected: {
      "!text":
        '''
        This is some multiline
        text.


        Newlines are preserved.



        Really!
        '''
    }

  it 'preserves horizontal whitespace in text blocks',
    input:
      '''
      This is some multiline
        text.
       .
        .
          .
             .
                    .
                               .
       . 
           .  .
             .
      '''

    expected: {
      "!text":
        '''
        This is some multiline
          text.
         .
          .
            .
               .
                      .
                                 .
         . 
             .  .
               .
        '''
    }

  it 'can handle the complex example from the readme',
    input:
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
        "mixin": ["Scalable", "Movable"]
      }
    }

  it 'allows for multiple text bodies in an array form',
    input:
      '''
      @class:method:methodName
        @example
          This is my first example.
        @example
          This is my second.
        @example
          C-C-C-COMBO BREAKERR
      '''

    expected: {
      "class": {
        "method": {
          "methodName": {
            "example": [
              {"!text": "This is my first example."},
              {"!text": "This is my second."},
              {"!text": "C-C-C-COMBO BREAKERR"}
            ]
          }
        }
      }
    }

  it 'allows for multiple nested tags in an array form',
    input:
      '''
      @class:method:methodName
        @example
          @aaa
        @example
          @bbb
        @example
          @ccc
      '''

    expected: {
      "class": {
        "method": {
          "methodName": {
            "example": [
              {"aaa": true},
              {"bbb": true},
              {"ccc": true}
            ]
          }
        }
      }
    }

  it 'handles the keyword `constructor`',
    input:
      '''
      @test
        @constructor
          This should work.
      '''

    expected: {
      "test": {
        "constructor": {
          "!text": "This should work."
        }
      }
    }

  it 'allows for tag-value pairs to contain nested text',
    input:
      '''
      @test 42
        This should work.
      '''

    expected: {
      "test": {
        "!value": 42,
        "!text": "This should work."
      }
    }

  it 'always treats blank lines following tags as text blocks',
    input:
      '''
      @test
        
        This should work.
      '''

    expected: {
      "test": {
        "!text": "\nThis should work."
      }
    }

  it 'handles edge case where you have a list of items with tag-value pairs in each item',
    input:
      '''
      @aaa
        @bbb value1
          @xxx value2
            @yyy value3
        @bbb value4
          @xxx value5
            @yyy value6
      '''

    expected: {
      "aaa": {
        "bbb": [
          {
            "!value": "value1",
            "xxx": {
              "!value": "value2",
              "yyy": "value3"
            }
          },
          {
            "!value": "value4",
            "xxx": {
              "!value": "value5",
              "yyy": "value6"
            }
          }
        ]
      }
    }

  it 'handles edge case of immediate text inside second list item with a value (issue #4)',
    input:
      '''
      @a
        @b 1
          x
        @b 2
          y
        @b 3
          z
      '''

    expected: {
      "a": {
        "b": [
          {
            "!value": 1,
            "!text": "x"
          },
          {
            "!value": 2,
            "!text": "y"
          },
          {
            "!value": 3,
            "!text": "z"
          }
        ]
      }
    }
