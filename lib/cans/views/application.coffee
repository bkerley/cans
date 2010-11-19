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
      Ajax '/image', (data) =>
        this.consume data
    consume: (returned) ->
      @modules = _.map returned.modules, (m) ->
        new Module(m)

  window.CurrentMachine = new Machine()

  class window.Module
    constructor: (@name) ->