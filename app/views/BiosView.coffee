# get the requirements
application = require('application')
BiosModel = require 'models/biosModel'
BiosCollection = require 'models/biosCollection'
# Bios = new BiosCollection
BioView = require 'views/BioView'	
# bioView = new BioView()

module.exports = class BiosView extends Backbone.Marionette.LayoutView
	template: 'views/templates/bios'
	id: 'bios'
	$el: $('#bios')
	
	# shoud be bios- if used
	# childView: bioView

	initialize: ->
		if application.GraphModule.getGraph() is undefined
			application.GraphModule.makeGraph()
	
	onShow: ->
		$(document).ready =>
			_margin = 
				t: 20
				l: 30
				b: 30
				r: 30
			width = 800
			height = 800
			Height = height
			Width = width
			@_m = application.GraphModule.getMap()
			
			# @el = $('#region-bios')
			# ajax the data, when load setup
			d3.json 'http://localhost:3001/bios', (error, text) =>
				application.GraphModule.makeControler(@$el, Width, Height, _margin, text, @_m)	
				# console.log "@_m", @_m
				# console.log textControl
				@_m.whenReady =>
					console.log "mapredy"
				
				# @el = $('#region-bios')
				# creat a DOM elements and add to the view
				
		