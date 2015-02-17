application = require('application')
application.module 'GraphModule', (GraphModule, App, Backbone, Marionette, $, _, d3) ->
  # The context of the function is also the module itself
  this == GraphModule
  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'

  myFunction = ->
    console.log myData
    return

  # Public Data And Functions
  # -------------------------
  GraphModule.someData = 'public data'

  GraphModule.someFunction = ->
    console.log "d3", d3
    console.log "looks like this is the best!"
    return

  return





