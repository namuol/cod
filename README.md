<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

# Cod [![Build Status](https://drone.io/github.com/namuol/cod/status.png)](https://drone.io/github.com/namuol/cod/latest)

Cod is an unopinionated documentation generator that outputs raw JSON.

### Example

Usage: (`build.js`)

```js
var cod = require('cod'),
    file = require('file-util'),
    input = file.read('Rectangle.coffee'),
    result;

result = cod(input, {
  open: '###*',
  close: '###'
});

file.write('docs/Rectangle.json', result);
```

Input: (`Rectangle.coffee`)

```coffee
###*
@Rectangle
  A four-sided shape with all right angles.

  @extends Shape
###
class Rectangle extends Shape
  ###*
  @Rectangle:method:area
    Get the area of this rectangle.
    @return
      The area of this rectangle.
      @type Number
  ###
  area: -> return @width * @height

###
This wont be in the docs!
###

###*
@Rectangle:mixin Scalable
###
mixin(Rectangle, Scalable)

###*
@Rectangle:mixin Movable
###
mixin(Rectangle, Movable)
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
    "mixin": ["Scalable", "Movable"]
  }
}
```

### Syntax

Anything starting with `@` is a "tag".

Tags can contain anything except `:` or whitespace.

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
@tag value
```


```json
{
  "tag": "value"
}
```

----

```
@root
  @tag value
```

```json
{
  "root": {
    "tag": "value"
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

### Install

```bash
npm install cod
```

### License

MIT

---

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/cod/README.md)](https://github.com/igrigorik/ga-beacon)
