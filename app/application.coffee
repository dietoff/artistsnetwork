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
            @vent = new Backbone.Wreqr.EventAggregator()
            @vent.on 'addNodes', (d) ->
                Backbone.history.navigate "graph/#{d.name}", trigger: true 
            @vent.on 'getLinksBy', (d) =>
                @GraphModule.Controller.getLinksBy(d)
            @router = new Router()
        )

        @start()



module.exports = new Application()
