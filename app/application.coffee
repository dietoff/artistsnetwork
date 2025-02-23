require 'lib/view_helper'
class Application extends Backbone.Marionette.Application
    initialize: =>
         
        @on("start", (options) =>
            Backbone.history.start()
            # Freeze the object
            Object.freeze? this
        )
        
        @addInitializer( (options) =>
            # set the modules/apps within the apllication
            # to start when application initialised
            AppLayout = require 'views/AppLayout'
            @layout = new AppLayout()
            HeaderFooter = require 'lib/HeaderFooter'
            @layout.on "render", =>
                console.log "onRender"
                @module("HeaderFooter").start()
            @layout.render()

            # NetworkLayout = require 'views/NetworkView'
            # @networkView = new NetworkLayout()
            # @layout.getRegion('content').show(@networkView)
            # @networkView.render()
            # @networkView.getRegion('region1').show(layout2);
            # layout2.getRegion('region2').show(layout3);
            
        )

        @addInitializer((options) =>
            # Instantiate the router

            Router = require 'lib/router'            
            OrgGraph = require 'lib/OrgGraph'
            PersonModule = require 'lib/PersonModule'
            BiotrajModule = require 'lib/BiotrajModule'
            
            @vent = new Backbone.Wreqr.EventAggregator()
            @vent.on 'netwotk', () ->
                Backbone.history.navigate "", trigger: false
                Backbone.history.navigate "location", trigger: false 
            @vent.on 'addNodes', (d) ->
                Backbone.history.navigate "graph/#{d.name}", trigger: true 
            @vent.on 'getLinksBy', (d) =>
                @GraphModule.Controller.getLinksBy(d)
            @vent.on 'organization', () =>
                # @("OrgGraph").start()
                @OrgGraph.Controller.OrgGraph()  
                Backbone.history.navigate "", trigger: false
                Backbone.history.navigate "organization", trigger: false 
            @vent.on "person", () =>
                console.log "preson in vent"
                console.log @
                # @module("PersonModule").start()
                # Backbone.history.navigate "", trigger: false
                @module("PersonModule").start()
                Backbone.history.navigate "person", trigger: false
                # @router.controller.personView()
            @vent.on "biotraj", () =>
                console.log "biotraj in vent"
                # @module("BiotrajModule").start()
                # Backbone.history.navigate "", trigger: false
                @module("BiotrajModule").start()
                Backbone.history.navigate "biotraj", trigger: false
                # @router.controller.personView()
            @router = new Router()
        )

        @start()



module.exports = new Application()
