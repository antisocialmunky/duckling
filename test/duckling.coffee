should = require('chai').should()
duckling = require '../src/duckling'

describe 'duckling.Type', ->
  it 'should construct with a name', ->
    duckling.clear()

    type = new duckling.Type('type')
    type.name.should.equal 'type'
    type.should.equal duckling.types['type']

  it 'should classify correctly', ->
    duckling.clear()

    hasChecked = false
    type = new duckling.Type('Position')
      .check((clas)->
        hasChecked = true
        return clas.x? && clas.y?)
    
    class Test
      x: 1 
      y: 1

    duckling.classify(Test)

    hasChecked.should.equal true
    Test.type.should.equal Test.prototype._type
    Test.type.should.equal duckling.types['Position'].id

  it 'should clear correctly', ->
    duckling.clear()

    type = new duckling.Type('Position')
      .check((clas)->
        hasChecked = true
        return clas.x? && clas.y?)
    
    class Test
      x: 1 
      y: 1

    duckling.classify(Test)

    duckling.types['Position'].should.equal type
    duckling.classes.indexOf(Test).should.not.equal -1

    duckling.clear()

    should.not.exist(duckling.types['Position'])
    duckling.classes.indexOf(Test).should.equal -1

  it 'should classify by priority (earlier types preempt)', ->
    duckling.clear()

    hasChecked1 = false
    hasChecked2 = false

    type1 = new duckling.Type('a1')
      .check((clas)->
        hasChecked1 = true
        return clas.a?)

    type2 = new duckling.Type('a2')
      .check((clas)->
        hasChecked2 = true
        return clas.a?)
    
    class Test
      a: 1

    duckling.classify(Test)

    hasChecked1.should.equal true
    hasChecked2.should.equal false
    Test.type.should.equal Test.prototype._type
    Test.type.should.equal duckling.types['a1'].id

  it 'should classify and not classify', ->
    duckling.clear()

    type1 = new duckling.Type('!a')
      .check((clas)->
        return !clas.a?)

    type2 = new duckling.Type('a')
      .check((clas)->
        return clas.a?)
    
    class Test
      a: 1

    duckling.classify(Test)

    Test.type.should.equal Test.prototype._type
    Test.type.should.equal duckling.types['a'].id

  it 'should fullfill my usecase!', ->
    duckling.clear()

    type1 = new duckling.Type('!a')
      .check((clas)->
        return !clas.a?)

    type2 = new duckling.Type('a')
      .check((clas)->
        return clas.a?)
    
    class Test1
      a: 1

    class Test2
      b: 2

    duckling.classify(Test1)
    duckling.classify(Test2)

    Test1.type.should.equal Test1.prototype._type
    Test1.type.should.equal duckling.types['a'].id

    Test2.type.should.equal Test2.prototype._type
    Test2.type.should.equal duckling.types['!a'].id

    test1 = new Test1()
    test2 = new Test2()

    test1Checked = false
    test2Checked = false

    classify = (obj)->
      test1Checked = false
      test2Checked = false
      switch obj._type
        when Test1.type
          test1Checked = true
        when Test2.type
          test2Checked = true

    classify(test1)
    test1Checked.should.be.true
    test2Checked.should.be.false

    classify(test2)
    test1Checked.should.be.false
    test2Checked.should.be.true
