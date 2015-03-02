application = require('application')

application.module 'HeaderFooter', (HeaderFooter, App, Backbone, Marionette, $, _) ->
  @startWithParent = false
  HeaderFooter.Controller =

      HeaderFooter: =>
        console.log "makeHeaderFooter"
        return
      Location: =>
        application.ViewController.network()
        return
      Person: =>
        console.log "person in header modfu;e"
        return
        


      # write methods
      # # getAllNodes
      # # getNodesBy(name, value)

  class HeaderFooter.Router extends Marionette.AppRouter
    appRoutes:
      "HeaderFooter" : "HeaderFooter"
      'location' : 'Location'
      'person' : 'Person'

  API = 

    HeaderFooter: () ->
      HeaderFooter.Controller.HeaderFooter()   

    Location: () ->
      application.vent.trigger "network"
      
    Person: () ->
      application.vent.trigger "person"
      # HeaderFooter.Controller.Person()

  HeaderFooter.addInitializer ->
    new HeaderFooter.Router
      controller: API 
  HeaderFooter.addInitializer ->
    module.exports = class HeaderFooter extends Backbone.Marionette.LayoutView
          template: 'views/templates/headerfooter'
          id: 'header'
          el: '#header'
          ui: 'switch-organization' : '#organization'
          triggers: 'click @ui.switch-organization' : 'switch-organization:do:view'
          regions:
            header: "#header"
        initialize: ->
        onShow: ->
          $(document).ready =>
            @on "switch-organization:do:view", =>
            console.log "switch-organization trigger"
            # @biosView = new BiosView()      
            # @regionBios.show(@biosView)
            # @orgGraphView = new OrgGraphView()
            # @regionGraph.show(@orgGraphView)
            # application.GraphModule.Controller.makeOrgGraph()
    @layout = new HeaderFooter()
    # console.log headerView
    console.log application
    # application.layout.header.show("headerView")
    @layout.render()


  # The context of the function is also the module itself
  this == HeaderFooter

  # => true
  # Private Data And Functions
  # --------------------------
  myData = 'this is private data'

  # Public Data And Functions
  # -------------------------
  HeaderFooter.someData = 'public data'

  HeaderFooter.makeHeaderFooter = () ->
    console.log "makeHeaderFooter"

  