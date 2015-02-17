ArtistModel = require 'models/artistModel'
module.exports = class ArtistCollection extends Backbone.Collection
	url: 'http://localhost:3001/artists/'
	model: ArtistModel



	