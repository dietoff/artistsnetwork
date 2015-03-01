application = require('application')

application.module 'Butterfly', (Butterfly, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  Butterfly.Controller =

      butterfly: =>
        console.log "makeButterfly"
        
        return


      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class Butterfly.Router extends Marionette.AppRouter
    appRoutes:
      "butterfly" : "butterfly"

  API = 

    butterfly: () ->
      Butterfly.Controller.butterfly()   

  App.addInitializer ->
    new Butterfly.Router
      controller: API 
  # The context of the function is also the module itself
  this == Butterfly

  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'

  # Public Data And Functions
  # -------------------------
  Butterfly.someData = 'public data'

  Butterfly.makeButterfly = () ->
    console.log "makeButterfly"