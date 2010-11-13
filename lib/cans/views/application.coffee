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
  constructor: (moduleName) ->
    @moduleName = moduleName
  renderTo: (container) ->
    container.insert this.columnHTML("<li>#{@moduleName}</li>")
    @columnElement = Cans.columns.peek()

class Link
  constructor: ->
    @content = this.linkHTML('example')
  linkHTML: (contents) ->
    "<a href='#!/Module/#{contents}'>#{contents}</a>"
  renderTo: (container) ->
    container.insert @content

class ModuleLink extends Link
  constructor: (moduleName) ->
    @moduleName = moduleName
  linkHTML: ->
    super @moduleName

Cans.start()