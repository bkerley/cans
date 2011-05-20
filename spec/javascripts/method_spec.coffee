describe 'Method', ->
  module = null

  beforeEach ->
    module = new Module('SampleModule')

  it 'should take a name and module when constructed', ->
    method = new Method(module, 'SampleMethod')
    expect(method.module).toEqual module
    expect(method.name).toEqual 'SampleMethod'

  describe 'instance', ->
    method = null

    beforeEach ->
      method = new Method(module, 'SampleMethod')

    it 'should Ajax fetch when asked to load', ->
      spyOn jQuery, 'ajax'
      method.load()
      expect(jQuery.ajax).toHaveBeenCalled()