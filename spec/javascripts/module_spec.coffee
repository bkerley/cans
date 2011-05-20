require '/json2.js'
require '/jquery-1.4.4.min.js'
require '/underscore-min.js'
require '/backbone-min.js'
require '/application.js'

describe 'Module', ->
  it 'should take a name when constructed', ->
    module = new Module('SampleModule')
    expect(module.name).toEqual 'SampleModule'

  describe 'instance', ->

    module = null

    beforeEach ->
      module = new Module('SampleModule')
      view =
        trigger: (name) ->
          null
      spyOn view, 'trigger'
      module.view = view

    it 'should Ajax fetch when asked to load', ->
      spyOn jQuery, 'ajax'
      module.load()
      expect(jQuery.ajax).toHaveBeenCalled()

    it 'should consume ajax data', ->
      data =
        child_modules: ['SampleModule::Client']
        class_methods: ['locate_a_client']
        local_instance_methods: ['be_a_sample']
        inherited_instance_methods: ['be_an_object']
      module.consume(data)
      expect(module.childModules).toEqual([new Module('SampleModule::Client')])
      expect(module.classMethods).toEqual([new ClassMethod(module, 'locate_a_client')])
      expect(module.localInstanceMethods).toEqual([new InstanceMethod(module, 'be_a_sample')])
      expect(module.inheritedInstanceMethods).toEqual([new InstanceMethod(module, 'be_an_object')])
    describe 'consuming Ajax data', ->
      beforeEach ->
        data =
          child_modules: ['SampleModule::Client']
          class_methods: ['locate_a_client']
          local_instance_methods: ['be_a_sample']
          inherited_instance_methods: ['be_an_object']
        module.consume(data)

      it 'should notify the view that it loaded', ->
        expect(module.view.trigger).toHaveBeenCalledWith('loaded')