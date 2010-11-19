require '/json2.js'
require '/jquery-1.4.4.min.js'
require '/underscore-min.js'
require '/backbone-min.js'
require '/application.js'

describe 'Machine', ->

  it 'should Ajax fetch a list of modules when constructed', ->
    spyOn jQuery, 'ajax'
    machine = new Machine()
    expect(jQuery.ajax).toHaveBeenCalled()