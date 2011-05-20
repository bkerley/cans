require '/json2.js'
require '/jquery-1.4.4.min.js'
require '/underscore-min.js'
require '/backbone-min.js'
require '/application.js'

describe 'MachineView', ->
  it 'should live on window', ->
    expect(window.MachineView).toBeDefined()
  it 'should create a new Machine when started', ->
    spyOn window, 'Machine'
    window.MachineView.start()
    expect(window.Machine).toHaveBeenCalled()