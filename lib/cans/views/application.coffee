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
    constructor: () ->
      this.load()
    load: ->
      Ajax '/image', (data) =>
        this.consume data
    consume: (returned) ->
      @modules = _.map returned.modules, (m) ->
        new Module(m)
      @view.trigger 'loaded'

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
      Ajax this.url(), (data) =>
        this.consume data
    consume: (returned) ->
      @source = returned.source
      if @source
        @source_file = returned.source_location[0]
        @source_line = returned.source_location[1]
      this.view.trigger 'loaded'
    url: ->
      "/method/#{escape(@module.name)}/.#{escape(@flavor)}/#{escape(@name)}"
    toJSON: ->
      module: @module.toJSON()
      name: @name
      source: @source
      file: @source_file
      line: @source_line
      flavor: @flavor
      flavorSymbol: @flavorSymbol

  class window.InstanceMethod extends window.Method
    flavor: 'i'
    flavorSymbol: '#'

  class window.ClassMethod extends window.Method
    flavor: 'm'
    flavorSymbol: '::'

  window.SourceView = Backbone.View.extend
    tagName: 'div'
    template: _.template($('#source_template').html())
    errorTemplate: _.template($('#source_error_template').html())
    render: ->
      if @model.source
        return this.renderOkay()
      else
        return this.renderError()
    renderOkay: ->
      rendered = @template(@model.toJSON())
      $(@el).html(rendered)
      return this
    renderError: ->
      rendered = @errorTemplate(@model.toJSON())
      $(@el).html(rendered)
      return this

  window.MethodView = Backbone.View.extend
    tagName: 'li'
    template: _.template($('#method_template').html())
    events:
      'click': 'loadSource'
    initialize: ->
      @model.view = this
      this.bind 'loaded', this.drawSource
    loadSource: ->
      $('#content').html('')
      @model.load()
      false
    drawSource: ->
      sourceView = new SourceView({model: @model})
      $('#content').html(sourceView.render().el)
      SyntaxHighlighter.highlight({}, $('#content pre')[0])
    render: ->
      rendered = this.template(this.model.toJSON())
      $(this.el).html(rendered)
      $(this.el).addClass(this.model.flavor)
      return this

  window.ModuleView = Backbone.View.extend
    tagName: 'li'
    template: _.template($('#module_template').html())
    events:
      'click': 'loadChildren'
    initialize: ->
      @model.view = this
      this.bind 'loaded', this.drawChildren
    loadChildren: ->
      $('#class_method_list').html('')
      $('#instance_method_list').html('')
      $('#content').html('')
      $(@el).children('.child_modules').html('')
      @model.load()
      false
    drawChildren: ->
      this.drawChildModules()
      this.drawClassMethods()
      this.drawInstanceMethods()
    drawClassMethods: ->
      _(this.model.classMethods).each (m) ->
        view = new MethodView({model: m})
        $('#class_method_list').append(view.render().el)
    drawInstanceMethods: ->
      _(this.model.localInstanceMethods).each (m) ->
        view = new MethodView({model: m})
        $('#instance_method_list').append(view.render().el)
      _(this.model.inheritedInstanceMethods).each (m) ->
        view = new MethodView({model: m})
        $('#instance_method_list').append(view.render().el)
    drawChildModules: ->
      _(this.model.childModules).each (m) =>
        view = new ModuleView({model: m})
        $(@el).children('.child_modules').append(view.render().el)
    render: ->
      rendered = this.template(this.model.toJSON())
      $(this.el).html(rendered)
      return this

  window.MachineView = Backbone.View.extend
    initialize: ->
      @model.view = this
      this.bind 'loaded', this.drawModules
    drawModules: ->
      _(@model.modules).each (m)->
        view = new ModuleView({model: m})
        $('#module_list').append(view.render().el)

  window.App = new window.MachineView({model: new window.Machine})
