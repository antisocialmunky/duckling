should = require('chai').should()
duckling = require '../src/duckling'

describe 'duckling.Type', ->
  it 'should construct with a name', ->
    type = new duckling.Type('type')
    type.name.should.equal 'type'
    type.should.equal duckling.types['type']

  it 'should classify correctly', ->
    hasChecked = false
    type = new duckling.Type('Position')
    type.check((clas)->
      hasChecked = true
      return clas.x? && clas.y?)
    
    class Test
      x: 1 
      y: 1

    duckling.classify(Test)
    hasChecked.should.equal true
    Test.type.should.equal Test.prototype._type
    Test.type.should.equal duckling.types['Position'].id

  it 'should classify by priority (earlier types preempt)', ->
    hasChecked1 = false
    hasChecked2 = false

    type = new duckling.Type('a1')
    type.check((clas)->
      hasChecked1 = true
      return clas.a?)

    type = new duckling.Type('a2')
    type.check((clas)->
      hasChecked2 = true
      return clas.a?)
    
    class Test
      a: 1

    duckling.classify(Test)
    hasChecked1.should.equal true
    hasChecked2.should.equal false
    Test.type.should.equal Test.prototype._type
    Test.type.should.equal duckling.types['a1'].id