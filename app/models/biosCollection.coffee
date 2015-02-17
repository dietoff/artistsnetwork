BiosModel = require 'models/biosModel'
module.exports = class BiosCollection extends Backbone.Collection
	url: 'http://localhost:3001/bios/'
	model: BiosModel