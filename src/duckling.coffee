typeId = 0

class Type
  id: 0
  name: ''
  predicate: null
  constructor: (name)->
    @id = typeId++
    @name = name
    Duckling.types[name] = @
  check: (predicate)->
    if typeof predicate == 'function'
      oldPredicate = @predicate
      if oldPredicate?
        newPredicate = (clas) ->
          return predicate(clas) && oldPredicate(clas)
        @predicate = newPredicate
      else
        @predicate = predicate
    Duckling.reclassify()
    return @

Duckling = 
  types: {}
  classes: []
  clear: ()->
    Duckling.types = {}
    Duckling.classes.length = 0
    typeId = 0
  classify: (clas)->
    for name, type of Duckling.types
      if type.predicate? && type.predicate(clas.prototype)
        clas.type = type.id
        clas.prototype._type = type.id
        if Duckling.classes.indexOf(clas) == -1
          Duckling.classes.push(clas)
        return
  reclassify: ()->
    for clas in Duckling.classes
      Duckling.classify(clas)
  type: (name)->
    return new Type(name)

module.exports = Duckling if module?