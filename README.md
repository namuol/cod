# Cod

An unopinionated and unassuming documentation generator.

<p align="center">
  <img src="http://i.imgur.com/Owgsb3R.jpg"/>
</p>

(NOTE: Cod is currently just a concept; development is in-progress)

### Concept/Example

```coffee
###
@Rectangle
  @extends Shape
  A four-sided shape with all right angles.
###
class Rectangle extends Shape
  ###
  @Rectangle:method:area
    Get the area of this rectangle.
    @return
      The area of this rectangle.
      @type=Number
  ###
  area: -> return @width * @height
  
###
@Rectangle:mixins Scalable
###
mixin(Rectangle, Scalable)

###
@Rectangle:mixins Movable
###
mixin(Rectangle, Movable)
```

```js
{
  "Rectangle": {
    "!body": "A four-sided shape with all right angles.",
    "extends": "Shape",
    "mixins": ["Scalable", "Movable"],
    "method": {
      "area": {
        "!body": "Get the area of this rectangle.",
        "return": {
          "!body": "The area of this rectangle.",
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
