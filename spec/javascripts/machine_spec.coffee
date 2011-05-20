describe 'Machine', ->

  it 'should Ajax fetch when constructed', ->
    spyOn jQuery, 'ajax'
    machine = new Machine()
    expect(jQuery.ajax).toHaveBeenCalled()

  describe 'instance', ->

    machine = null

    beforeEach ->
      spyOn jQuery, 'ajax'
      view =
        trigger: (name) ->
          null
      spyOn view, 'trigger'
      machine = new Machine()
      machine.view = view

    describe 'when receiving module data', ->
      beforeEach ->
        machine.consume(
          modules: ['Alpha', 'Bravo']
        )

      it 'should create empty module instances for each datum', ->
        expect(machine.modules).toEqual([new Module('Alpha'), new Module('Bravo')])

      it 'should notify the view when loaded', ->
        expect(machine.view.trigger).toHaveBeenCalledWith('loaded')