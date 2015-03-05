application = require('application')
# HomeView = require('views/HomeView')
NetworkView = require('views/NetworkView')
BiosView = require('views/BiosView')
GraphView = require('views/GraphView')
BiosModel = require 'models/biosModel'
BiosCollection = require 'models/biosCollection'
OrganizationView = require 'views/OrgGraphView'
# Bios = new BiosCollection
# Create a Controller, giving it the callbacks for our Router.
# MyController = Marionette.Controller.extend(
#   home: ->
#   profile: ->
# )
# # Instantiate it
# myController = new MyController
# # Pass it into the Router
# myRouter = new (Marionette.AppRouter)(
#   controller: myController
#   appRoutes:
#     'home': 'home'
#     'profile': 'profile')




# MyRouter = Backbone.Marionette.AppRouter.extend(
#   appRoutes: 'some/route': 'someMethod'
#   routes: 'some/otherRoute': 'someOtherMethod'
#   someOtherMethod: ->
#     # do something here.
#     return
# )
# MyController = Marionette.Controller.extend(
#   home: ->
#   profile: ->
# )
# # Instantiate it
# myController = new MyController
# # Pass it into the Router


module.exports = class Router extends Backbone.Marionette.AppRouter
	ViewController = Marionette.Controller.extend(

		network: ->
			$("svg").html("")
			$("svg").css("height", "0px")
			@nv = new NetworkView()
			application.layout.content.show(@nv)


		bios: ->
			# Bios = new BiosCollection()
			# Bios.fetch
			# 	done: (data) ->
			# 		models: data.toJSON()
			# 		# console.log data.toJSON()
			# 		text = data.toJSON
			# 		# @render
			# 		console.log "bios", Bios
			bv = new BiosView#(collection:Bios)
			application.layout.content.show(bv)
			# @layout = new AppLayout()
   			# @layout.render()

		addNodes: (node) ->
			if @nv is undefined
				@nv = new NetworkView()
				application.layout.content.show(@nv)
				@gv = new GraphView() 
				@nv.regionGraph.show(@gv)
			else if @gv is undefined
				@gv = new GraphView() 
				@nv.regionGraph.show(@gv)
				if application.GraphModule.getGraph() is undefined
					application.GraphModule.makeGraph()
			@gv.onThisArtist(node)

		offArtist: ->
			@gv.offThisArtist()

		organization: ->
			@nv.remove(@graphView)
			# biosView = new BiosView()			
			# @nv.show(biosView)
			# orgGraphView = new OrgGraphView()
			# @nv.show(orgGraphView)
			# console.log "reouter organization"
			application.vent.trigger "organization"

		location: ->
			console.log "application in ;ocation call"
			if @nv is undefined
				@nv = new NetworkView()
				application.layout.content.show(@nv)
				@gv = new GraphView() 
				@nv.regionGraph.show(@gv)
			else if @gv is undefined
				@gv = new GraphView() 
				@nv.regionGraph.show(@gv)
				if application.GraphModule.getGraph() is undefined
					application.GraphModule.makeGraph()
			application.vent.trigger "location"
		
		personView: ->
			console.log "personview in ViewController"
			@nv.remove(@gv)
			application.PersonModule.putPersonGraph()
			# @nv.regionGraph.show()
		biotrajView: ->
			console.log "biotraj in ViewController"
			@nv.remove(@gv)
			application.BiotrajModule.putBiotrajGraph()
		
	)

	ViewController = new ViewController
	controller: ViewController
	appRoutes:
		'': 'network'
		'bios' : 'bios'
		'graph/:node': 'addNodes'
		'offArtist' : 'offArtist'	
		'organization' : 'organization'
		'location' : 'location'
		'person' : 'personView'
		'biotraj' : 'biotrajView'