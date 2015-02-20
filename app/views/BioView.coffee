# not used

module.exports = class BioView extends Backbone.Marionette.ItemView
	template: 'views/templates/Bio'
	# id: 'region-graph'

	onShow: ->
		console.log "inside Bio item view"