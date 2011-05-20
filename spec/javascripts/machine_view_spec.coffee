describe 'MachineView', ->
  it 'should exist', ->
    expect(MachineView).toBeDefined()
  it 'should create a new Machine when started', ->
    spyOn window, 'Machine'
    window.MachineView.start()
    expect(window.Machine).toHaveBeenCalled()