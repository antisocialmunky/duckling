#Introduction
A duck-type library that I can use with a switch statement.

#Duckling
**noun**

A duckling is a young duck in downy plumage or baby duck; but in the food trade young adult ducks ready for roasting are sometimes labelled "duckling".

#Features
* This library allows you to create duck type definitions
* You can then identify classes in a switch statement

#Usage

####Type = duckling.type(name)
Create a new type with a name.

####Type = Type.check(predicate)
Add a predicate to the type.  Predicates are run against the prototype of a class when it is classified.  Reclassification is done whenever a predicate is added to any type.  It is therefore recommended that types are initialized before classification happens.

####duckling.classify(class)
Run class against all created types.  A member variable **._type** is added to the class prototype and a **type** static is added to the class itself.

####duckling.reclassify()
Reclassify all previously classified classes.  This is automatically run whenver any type definition is updated.

#Example

```coffeescript
require 'duckling'

hasPosition = (clas)->
  return clas.x? && clas.y?

moves = (clas)->
  return clas.velocity?

hasSprite = (clas)->
  return clas.sprite?

#Order is important
#Since Actors have positions, it needs to be defined first.

ActorType = duckling.type('Actor').check(hasPosition).check(hasSprite).check(moves)
StaticType = duckling.type('Position').check(hasPosition).check(hasSprite)

#Create some sort of game and load it with a bunch of objects
...

update = (objects) ->
  for object in objects
    switch object._type
      when ActorType.type
        #move sprite by adding velocity to position
        #do collision detection
        #render the sprite
      when StaticType.type
        #render the sprite only
```

#License
Copyright (c) 2014 David Tai

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
