Cans =
  start: ->
    @columns = new Columns

class Columns
  constructor: ->
    @columnContainer = $('columns')
    @columns = []
    this.push(new RootColumn)
  push: (column) ->
    @columns.push(column)
    column.renderTo @columnContainer

class Column
  columnHTML: (contents) ->
    "<li><ul>#{contents}</ul></li>"
  renderTo: (container) ->
    @column = this.columnHTML("<li>example</li>")
    container.append @column
  request: (path, callback) ->
    new Ajax.Request(document.location.pathname + '/' + path, onSuccess: callback)

class RootColumn extends Column
  renderTo: (container) ->
    this.request 'r', (response) =>
      content = ''
      for e in response.responseJSON.modules
        content += "<li>#{e}</li>"
      @column = this.columnHTML(content)
      container.insert @column

Cans.start()