Cans =
  start: ->
    @columns = new Columns

class Columns
  constructor: ->
    @columnContainer = $('columns')
    @columns = $A()
    this.push(new RootColumn)
  push: (column) ->
    @columns.push(column)
    column.renderTo @columnContainer
  peek: ->
    lis = @columnContainer.select('>li')
    lis.last()
  popAfter: (column) ->
    while @columns.last() != column
      c = @columns.last()
      @columns.pop()
      c.remove()

class Column
  columnHTML: (contents) ->
    "<li><ul>#{contents}</ul></li>"
  renderTo: (container) ->
    @column = this.columnHTML("<li>example</li>")
    container.append @column
    @columnElement = Cans.columns.peek()
  request: (path, callback) ->
    new Ajax.Request(document.location.pathname + '/' + path, onSuccess: callback)
  remove: ->
    @columnElement.remove()

class RootColumn extends Column
  renderTo: (container) ->
    this.request 'r', (response) =>
      content = ''
      links = $A()
      for e in response.responseJSON.modules
        links.push new ModuleLink(e)
      htmlLinks = links.map (l) ->
        "<li>#{l.linkHTML()}</li>"
      @column = this.columnHTML htmlLinks.join('')
      container.insert @column
      @columnElement = Cans.columns.peek()
      @columnElement.on('click', 'a', (e) =>
        Cans.columns.popAfter(this)
        Cans.columns.push(new ModuleColumn(e.target.innerHTML))
        return false
        )

class ModuleColumn extends Column
  constructor: (@moduleName) ->
  renderTo: (container) ->
    this.request "m/#{@moduleName.gsub('::','/')}", (response) =>
      content = ''
      local_instances = $A()
      class_methods = $A()
      child_modules = $A()
      inherited_instances = $A()
      for e in response.responseJSON.local_instance_methods
        local_instances.push new InstanceMethodLink(@moduleName, e)
      for e in response.responseJSON.class_methods
        class_methods.push new ClassMethodLink(@moduleName, e)
      for e in response.responseJSON.child_modules
        child_modules.push new ModuleLink(e)
      for e in response.responseJSON.inherited_instance_methods
        inherited_instances.push new InstanceMethodLink(@moduleName, e)

      allLinks = $A()
      allLinks.push new FakeHeaderLink('Class Methods')
      allLinks = allLinks.concat class_methods
      allLinks.push new FakeHeaderLink('Local Instance Methods')
      allLinks = allLinks.concat local_instances
      allLinks.push new FakeHeaderLink('Inherited Methods')
      allLinks = allLinks.concat inherited_instances
      allLinks.push new FakeHeaderLink('Child Modules')
      allLinks = allLinks.concat child_modules

      htmlLinks = allLinks.map (l) ->
        "<li>#{l.linkHTML()}</li>"

      @column = this.columnHTML htmlLinks.join('')
      container.insert @column
      @columnElement = Cans.columns.peek()

    @columnElement = Cans.columns.peek()

class Link
  constructor: ->
    @content = this.linkHTML('example')
  linkHTML: (contents) ->
    "<a href='#!/Module/#{contents}'>#{contents}</a>"

class FakeHeaderLink
  constructor: (@content) ->
  linkHTML: ->
    @content

class ModuleLink extends Link
  constructor: (@moduleName) ->
  linkHTML: ->
    super @moduleName

class MethodLink extends Link
  constructor: (@flavor, @moduleName, @methodName) ->
  linkHTML: ->
    "<a href='#!/Module/#{@moduleName.gsub('::','/')}/.#{@flavor}/#{@methodName}'>#{@methodName}</a>"

class InstanceMethodLink extends MethodLink
  constructor: (@moduleName, @methodName) ->
    super 'i', @moduleName, @methodName

class ClassMethodLink extends MethodLink
  constructor: (@moduleName, @methodName) ->
    super 'm', @moduleName, @methodName

Cans.start()