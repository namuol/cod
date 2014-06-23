<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

# cod [![Build Status](https://drone.io/github.com/namuol/cod/status.png)](https://drone.io/github.com/namuol/cod/latest) [![Module Version](http://img.shields.io/npm/v/cod.svg?style=flat)](https://www.npmjs.org/package/cod)

an unopinionated documentation generator that outputs raw JSON, designed to work with any language.

```bash
cod -o docs/Rectangle.json Rectangle.js
```

Input: (`Rectangle.js`)

```js
/**
@Rectangle
  A four-sided shape with all right angles.
  @extends Shape
*/

// ... code code code

/**
@Rectangle:method:area
  Get the area of this rectangle.
  @return
    @type Number
*/

/**
@Rectangle:mixin Scalable
@Rectangle:mixin Movable
*/

/**
@Rectangle:event:resized
  Fires whenever the width or height changes.
*/
```

Result: (`docs/Rectangle.json`)

```json
{
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
    "mixin": ["Scalable", "Movable"],
    "event": {
      "resized": {
        "!text": "Fires whenever the width or height changes."
      }
    },
  }
}
```

### CLI

```
cod --help
              ,
           _-""-,-"'._         
     .-*'``           ``-.__.-`:
  .'o   ))` ` ` ` ` ` `_`.---._:
   `-'.._,,____...--*"` `"     
         ``
cod: An unopinionated documentation generator.

Usage:
  cod [-b <doc-begin> -e <doc-end>] [-o <output-file>] <input-file>...
  cod -h | --help | --version

Options:
  -b <doc-begin>    String that marks the start of a doc-block [default: "/**"]
  -e <doc-end>      String that marks the end of a doc-block [default: "*/"]
  -o <output-file>  Output file [default: STDOUT]
  -v --version      Show version.
  -h --help         Show this screen.
```

### API

<a name='api_cod'></a>
#### [`cod(text, options={docBegin = "/**", docEnd = "*/"})`](#api_cod)

> <a name='api_cod_text'></a>
> [`text`](#api_cod_text) (String)
> > Text containing cod-style documentation. Probably source code.
>
> <a name='api_cod_options'></a>
> [`options`](#api_cod_options) (Object)
> > <a name='api_cod_options_docBegin'></a>
> > [`docBegin`](#api_cod_options_docBegin) (String) default: `"/**"`
> > > String that marks the start of a doc-block
>
> > <a name='api_cod_options_docEnd'></a>
> > [`docEnd`](#api_cod_options_docEnd) (String) default: `"*/"`
> > > String that marks the end of a doc-block

### Syntax

```
@flag
```

```json
{
  "flag": true
}
```

----

```
@number 42
@string Hello there.
@boolean false
```

```json
{
  "number": 42,
  "string": "Hello there.",
  "boolean": false
}
```

----

```
@example
  This is some example text.

  It can handle multiple lines.
    Indentation is preserved.
```

```json
{
  "example": {
    "!text": "This is some example text.\n\nIt can handle multiple lines.\n  Indentation is preserved."
  }
}
```

----

```
@root
  @nested value
```

```json
{
  "root": {
    "nested": "value"
  }
}
```

----

```
@list A
@list B
@list C
```

```json
{
  "list": [
    "A",
    "B",
    "C"
  ]
}
```

----

```
@root:inline:nested value
```

```json
{
  "root": {
    "inline": {
      "nested": "value"
    }
  }
}
```

----

```
@example This will be stored as example["!value"]
  This allows for nested text and tags.
  @likeThisOne 42
    @andThis
```

```json
{
  "example": {
    "!value": "This will be stored as example[\"!value\"]",
    "!text": "This allows for nested text and other properties.",
    "likeThisOne": {
      "!value": 42,
      "andThis": true
    }
  }
}
```

### Install

```bash
npm install cod
```

### License

MIT

---

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/cod/README.md)](https://github.com/igrigorik/ga-beacon)
