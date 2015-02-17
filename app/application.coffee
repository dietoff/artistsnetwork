require 'lib/view_helper'


class Application extends Backbone.Marionette.Application
    initialize: =>
         
        @on("start", (options) =>
            Backbone.history.start()
            # Freeze the object
            Object.freeze? this
        )

        # Application.vent = new Backbone.Wreqr.EventAggregator()
        
        @addInitializer( (options) =>

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
                console.log "vent works and this is d: ", d
                Backbone.history.navigate "graph/#{d.Name}", trigger: true 
            @router = new Router()
        )

        @start()



module.exports = new Application()
