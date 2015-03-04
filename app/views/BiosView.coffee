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
	ui: 'name': '#bio-list'
	# triggers: 'click @ui.name' : 'name:do:bio'
	# events: 'mouseover @ui.li': 'showBio'
	# triggers: 'mouseover @ui.li': 'show:bio'
	# shoud be bios- if used
	# childView: bioView

	initialize: ->
	
	onShow: ->
		_margin = 
				t: 20
				l: 30
				b: 30
				r: 30
			width = 800
			height = 800
			Height = height
			Width = width
		textResponse = $.ajax
                    url: "http://localhost:3001/artists"
                    success: (result) ->
                    	$el = $('#bios')
                    	application.GraphModule.makeDivList($el, Width, Height, _margin, result)
                    	application.GraphModule.makeBioController()	
				    	return
                # text = textResponse.complete()
                # text.done =>
                	# console.log text
                	# console.log text.responseJSON
		# @on "name:do:bio", =>
		# 	console.log "click on name on bioView"
		
				
		