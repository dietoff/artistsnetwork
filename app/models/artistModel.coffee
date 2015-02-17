module.exports = class ArtistModel extends Backbone.Model
	urlRoot: 'http://localhost:3001/artists/'
	idAttribute: '_id'
	defaults: {}