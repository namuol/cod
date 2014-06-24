<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

# cod [![Build Status](https://drone.io/github.com/namuol/cod/status.png)](https://drone.io/github.com/namuol/cod/latest) [![Module Version](http://img.shields.io/npm/v/cod.svg?style=flat)](https://www.npmjs.org/package/cod)

an unassuming documentation generator that works with any language.

----

Unlike most doc-generators, **cod** doesn't try to do everything for you.

You write your docs in its flexible format, and it faithfully outputs JSON.

```javascript
/**
@Something
  Text can go anywhere.
     Whitespace is preserved.
  @flag
  @property 42
  @string Hello, cod
  @nested
    @property
  @list A
  @list B
  @list C
*/

// Later...

/**
@Something:extension
  Tags can be "re-opened"
*/
```

```json
{
  "Something": {
    "!text": "Text can go anywhere.\n   Whitespace is preserved.",
    "flag": true,
    "property": 42,
    "string": "Hello, cod",
    "nested": {
      "property": true
    },
    "list": ["A", "B", "C"],
    "extension": {
      "!text": "Tags can be \"re-opened\""
    }
  }
}
```

Use whatever tags you need.

Anything that isn't a `@tag` is text.

It leaves your text untouched. You can process it as Markdown later. Or HTML. Or just keep it as plain text.

Once you have the JSON, feed it to whatever you want:

  - Utilize existing templates and styles.
  - Build an app that can consume multiple versions of your API docs.
  - Easily compare specific versions of your API at the structural level.

**[cod](http://github.com/namuol/cod)** is language-agnostic; all it needs to know is the pattern that your project uses to denote a doc-block (i.e. `/**` and `*/`).

### CLI

```
cod *.js # or *.go or *.c or ...
cod -b '###*' -e '###' *.coffee
cod -b "'''*" -e "'''" *.py
cod -b '{-*' -e '-}' *.hs
cod -b '--[[*' -e ']]' *.lua
```

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
  -b <doc-begin>    String that marks the start of a doc-block [default: /**]
  -e <doc-end>      String that marks the end of a doc-block [default: */]
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

### syntax

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

### install

```bash
npm install cod
```

### license

MIT

---

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/cod/README.md)](https://github.com/igrigorik/ga-beacon)
