jQuery ->
  jQuery.ajaxSetup(
    type: 'post'
    dataType: 'json'
  )

  # cans-based ajax helper, since we don't necessarily know where
  # cans has been mounted
  Ajax = (path, callback) ->
    fullPath = window.location.pathname + path
    jQuery.ajax(
      url: fullPath
      success: callback
    )

  # the top-level view of the Ruby VM image
  class window.Machine
    constructor: ->
      self.load
    load: ->
      Ajax '/image', (data) =>
        this.consume data
    consume: (returned) ->
      @modules = _.map returned.modules, (m) ->
        new Module(m)

  window.CurrentMachine = new Machine()

  class window.Module
    constructor: (@name) ->
    load: ->
      Ajax "/module/#{@name}", (data) =>
        this.consume data
    consume: (returned) ->
      @childModules = _.map returned.child_modules, (m) => new Module(m)
      @classMethods = _.map returned.class_methods, (m) => new ClassMethod(this, m)
      @localInstanceMethods = _.map returned.local_instance_methods, (m) => new InstanceMethod(this, m)
      @inheritedInstanceMethods = _.map returned.inherited_instance_methods, (m) => new InstanceMethod(this, m)

  class window.Method

  class window.InstanceMethod
    constructor: (@module, @name) ->

  class window.ClassMethod
    constructor: (@module, @name) ->