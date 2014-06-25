<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

# cod [![Build Status](https://drone.io/github.com/namuol/cod/status.png)](https://drone.io/github.com/namuol/cod/latest) [![Module Version](http://img.shields.io/npm/v/cod.svg?style=flat)](https://www.npmjs.org/package/cod) [![Dependency Status](http://img.shields.io/david/namuol/cod.svg?style=flat)](https://david-dm.org/namuol/cod)

An unassuming documentation generator that works with any language.

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

**cod** is language-agnostic; all it needs to know is the pattern that your project uses to denote a doc-block (i.e. `/**` and `*/`).

### CLI

```
cod *.js # or *.go or *.c or ...
cod -b '###*' -e '###' *.coffee
cod -b "'''*" -e "'''" *.py
cod -b '{-*' -e '-}' *.hs
cod -b '--[[*' -e ']]' *.lua
```

```
cat *.js | cod  > api.json
```

```
cod --help
              ,
           _-""-,-"'._         
     .-*'``           ``-.__.-`:
  .'o   ))` ` ` ` ` ` `_`.---._:
   `-'.._,,____...--*"` `"     
         ``
cod: An unassuming documentation generator.

Usage:
  cod [-b <doc-begin> -e <doc-end>] [-o <output-file>] [-u] [<input-file>...]
  cod -h | --help | --version

Options:
  -b <doc-begin>    String that marks the start of a doc-block [default: /**]
  -e <doc-end>      String that marks the end of a doc-block [default: */]
  -o <output-file>  Output file [default: STDOUT]
  -u --ugly         Output non-pretty JSON.
  -v --version      Show version.
  -h --help         Show this screen.
  <input-file>...   File(s) containing docs. If none, cod reads from STDIN.
```

### gulp

See [gulp-cod](http://github.com/namuol/gulp-cod).

### Grunt

[Create an issue](http://github.com/namuol/cod/issues) if you make a Grunt plugin for cod, and I'll list it here.

### API

<a name='api_cod'></a>
#### [`cod([[text,] options])`](#api_cod)
> If [`text`](#api_cod_text) is supplied, cod will parse it and return
> a plain JS object that contains your doc structure.
> 
> Otherwise, cod will return a [Transform stream](http://nodejs.org/api/stream.html#stream_class_stream_transform) into which
> your source can be [piped](http://nodejs.org/api/stream.html#stream_readable_pipe_destination_options).
> `cod` will buffer the stream until completion, after which it will output
> the stringified JSON of your doc's structure.
>  
> <a name='api_cod_text'></a>
> [`text`](#api_cod_text) (String | Buffer)
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
>
> > <a name='api_cod_options_pretty'></a>
> > [`pretty`](#api_cod_options_pretty) (boolean) default: `true`
> > > Format the JSON output with `JSON.stringify(doc, null, 2)`
> > > **Only applicable in stream mode when `text` is not supplied**

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
npm install -g cod
```

### license

MIT

---

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/cod/README.md)](https://github.com/igrigorik/ga-beacon)
