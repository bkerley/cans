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
    constructor: (@machineView) ->
      this.load()
    load: ->
      Ajax '/image', (data) =>
        this.consume data
    consume: (returned) ->
      @modules = _.map returned.modules, (m) ->
        new Module(m)
      @machineView.trigger 'loaded'

  class window.Module
    constructor: (@name) ->
      @view = null
    load: ->
      Ajax "/class/#{@name}", (data) =>
        this.consume data
    consume: (returned) ->
      @childModules = _.map returned.child_modules, (m) => new Module(m)
      @classMethods = _.map returned.class_methods, (m) => new ClassMethod(this, m)
      @localInstanceMethods = _.map returned.local_instance_methods, (m) => new InstanceMethod(this, m)
      @inheritedInstanceMethods = _.map returned.inherited_instance_methods, (m) => new InstanceMethod(this, m)
      this.view.trigger 'loaded'
    toJSON: ->
      name: @name

  class window.Method
    constructor: (@module, @name) ->
    load: (flavor) ->
      Ajax "/#{@module.name}/.#{flavor}/#{@name}", (data) =>
        this.consume data

  class window.InstanceMethod extends window.Method

  class window.ClassMethod extends window.Method

  window.ModuleView = Backbone.View.extend
    tagName: 'li'
    template: _.template($('#module_template').html())
    events:
      'click': 'loadMethods'
      'loaded': 'drawMethods'
    initialize: ->
      this.model.view = this
    loadMethods: ->
      this.model.load()
    drawMethods: ->
      this.model.localInstanceMethods.each (m) ->
        $('#method_list').append m.name
    render: ->
      rendered = this.template(this.model.toJSON())
      $(this.el).html(rendered)
      return this

  window.MachineView =
    start: ->
      _.extend(this, Backbone.Events);
      this.bind 'loaded', this.drawModules
      @model = new window.Machine(this)
    drawModules: ->
      _(@model.modules).each (m)->
        view = new ModuleView({model: m})
        $('#module_list').append(view.render().el)

  window.MachineView.start()