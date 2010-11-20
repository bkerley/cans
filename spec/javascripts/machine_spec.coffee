require '/json2.js'
require '/jquery-1.4.4.min.js'
require '/underscore-min.js'
require '/backbone-min.js'
require '/application.js'

describe 'Machine', ->

  it 'should Ajax fetch when constructed', ->
    spyOn jQuery, 'ajax'
    machine = new Machine()
    expect(jQuery.ajax).toHaveBeenCalled()

  describe 'instance', ->

    machine = null

    beforeEach ->
      spyOn jQuery, 'ajax'
      machine = new Machine();

    describe 'when receiving module data', ->
      beforeEach ->

      it 'should create empty module instances for each datum', ->
        machine.consume(
          modules: ['Alpha', 'Bravo']
        )
        expect(machine.modules).toEqual([new Module('Alpha'), new Module('Bravo')])