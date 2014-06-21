<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

# Cod [![Build Status](https://drone.io/github.com/namuol/cod/status.png)](https://drone.io/github.com/namuol/cod/latest)

An unopinionated documentation generator.

(NOTE: Cod is currently just a concept; development is in-progress)

### Concept/Example

Cod infers the structure and meaning of your documentation's tags as they are parsed,
allowing for an arbitrary structure.

```coffee
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
```

```json
{
  "Rectangle": {
    "!text": "A four-sided shape with all right angles.",
    "extends": "Shape",
    "mixin": ["Scalable", "Movable"],
    "method": {
      "area": {
        "!text": "Get the area of this rectangle.",
        "return": {
          "!text": "The area of this rectangle.",
          "type": "Number"
        }
      }
    }
  },
  "Shape": /* ... */,
  "Scalable": /* ... */,
  "Movable": /* ... */
}
```

### How the structure is created.
```
@Rectangle
```

```json
{
  "Rectangle": true
}
```

----

```
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.
```

```json
{
  "Rectangle": {
    "!text": "A four-sided shape with all right angles.",
    "extends": "Shape"
  }
}
```

----

```
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.

@Rectangle:method:area
```

```json
{
  "Rectangle": {
    "!text": "A four-sided shape with all right angles.",
    "extends": "Shape",
    "method": {
      "area": true
    }
  }
}
```

----

```
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.

@Rectangle:method:area
  Get the area of this rectangle.
  @return
    The area of this rectangle.
    @type Number

```

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
    }
  }
}
```

----

```
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.

@Rectangle:method:area
  Get the area of this rectangle.
  @return
    The area of this rectangle.
    @type Number

@Rectangle:mixin Scalable

```

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
    "mixin": "Scalable"
  }
}
```

----

```
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.

@Rectangle:method:area
  Get the area of this rectangle.
  @return
    The area of this rectangle.
    @type Number

@Rectangle:mixin Scalable
@Rectangle:mixin Movable

```

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
