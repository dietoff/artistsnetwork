express = require('express')
mongoose = require('mongoose')
config = 
  'db': 'artistdb/'
  'host': '127.0.0.1'
  'user': ''
  'pw': ''
  'port': 27017
port = if config.port.length > 0 then ':' + config.port else ''
login = if config.user.length > 0 then config.user + ':' + config.pw + '@' else ''
# var uristring =  "mongodb://" + login + config.host + config.port + "/" + config.db;
uristring = 'mongodb://127.0.0.1:27017/artistdb'
console.log 'connection'
mongoOptions = db: safe: true
# Connect to Database
mongoose.connect uristring, (err, res) ->
  if err
    console.log 'ERROR connecting to: ' + uristring + '. ' + err
  else
    console.log 'Successfully connected to: ' + uristring
  return
exports.mongoose = mongoose
app = express()
# define the schema from the dataset!
Schema = mongoose.Schema
BiosSchema = new Schema({
  _id: Schema.Types.ObjectId
  Name: String
  FirstParagraph: String
}, collection: 'samplebios')
ArtistSchema = new Schema({
  _id: Schema.Types.ObjectId
  source: String
  edgetype: String
  target: String
}, collection: 'artists')
ArtistNodesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Id: String
  type: String
}, collection: 'armorynode')
ArtistEdgesSchema = new Schema({
  _id: Schema.Types.ObjectId
  source: String
  target: String
  edgetype: String
}, collection: 'armoryedge')
OrgNodesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Id: String
  type: String
}, collection: 'orgnode')
OrgEdgesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Source: String
  Target: String
}, collection: 'orgedge')
LocNodesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Id: String
  type: String
}, collection: 'locnode')
LocEdgesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Source: String
  Target: String
}, collection: 'locedge')
DateNodesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Id: String
  type: String
}, collection: 'datenode')
DateEdgesSchema = new Schema({
  _id: Schema.Types.ObjectId
  Source: String
  Target: String
}, collection: 'dateedge')
# define the methods for the schma 

BiosSchema.methods.findLimited = (cb) ->
  query = @model('Bios').find({})
  query.limit()
  query.exec cb

ArtistSchema.methods.findLimited = (cb) ->
  query = @model('Artist').find({})
  query.limit(2000)
  query.exec cb

ArtistSchema.methods.findByTarget = (cb) ->
  query = @model('Artist').find({})
  query.where 'target', @target
  query.limit()
  query.exec cb

ArtistNodesSchema.methods.findLimited = (cb) ->
  query = @model('ArtistNodes').find({})
  query.limit()
  query.exec cb
ArtistNodesSchema.methods.findByType = (cb) ->
  query = @model('ArtistNodes').find({})
  query.where 'type', @type
  query.limit(100)
  query.exec cb
ArtistEdgesSchema.methods.findLimited = (cb) ->
  query = @model('ArtistEdges').find({})
  query.limit(50)
  query.exec cb

# declare mongoose models
mongoose.model 'Bios', BiosSchema
mongoose.model 'Artist', ArtistSchema
mongoose.model 'ArtistNodes', ArtistNodesSchema
mongoose.model 'ArtistEdges', ArtistEdgesSchema
Bios = mongoose.model('Bios')
Artist = mongoose.model('Artist')
ArtistNodes = mongoose.model('ArtistNodes')
ArtistEdges = mongoose.model('ArtistEdges')

exports.findAll = (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  Artist.find {}, (err, results) ->
    res.send results
  return

exports.findById = ->

exports.add = ->

exports.update = ->

exports.delete = ->


app.get '/bios', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  bios = Bios({})
  bios.findLimited (err, bios) ->
    res.json bios
  return
app.get '/artists', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  artist = Artist({})
  artist.findLimited (err, artist) ->
    res.json artist
    # Artist.findById(artist["_id"], function (err, docs) {
    #   if (!err) {
    #     each = docs;
    #     return res.json(each);
    #   } else {
    #     return console.log(err);
    #   }
    #   });
  return
app.get '/armorynodes', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  artist_nodes = ArtistNodes({})
  artist_nodes.findLimited (err, artist_nodes) ->
    res.json artist_nodes
  return
app.get '/armoryedges', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  artist_edges = ArtistEdges({})
  artist_edges.findLimited (err, artist_edges) ->
    res.json artist_edges
  return
# app.get('/artists_b/:id', function (req, res) {
#   res.header("Access-Control-Allow-Origin", "*"); 
#   res.header("Access-Control-Allow-Headers", "X-Requested-With");
#   var artist = new Artist({target: req.params.ta});
#     var query = Artist.find({}, function (err, docs) {
#         res.json(docs);
#     });
# });
# app.get('/count', function (req, res) {
#   res.header("Access-Control-Allow-Origin", "*"); 
#     res.header("Access-Control-Allow-Headers", "X-Requested-With");
#   Artist
#     .find({})
#     .sort({'date': -1})
#     .limit(20)
#     .exec(function(err, posts) {
#       if (err) {
#          res.render('error', {status: 500});
#       } else {
#         res.render('allposts', {posts: posts});
#       }
#     });
# });
app.get '/artstsby/:t', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  artist = new Artist(target: req.params.t)
  artist.findByTarget (err, artist) ->
    console.log artist
    Artist.findById artist[0]['_id'], (err, docs) ->
      if !err
        each = docs
        res.json each
      else
        console.log err
    return
  return

app.get '/artistsbytype/:t', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  artist = new ArtistNodes(type: req.params.t)
  artist.findByType (err, artist) ->
    console.log artist
    res.json artist
    # ArtistNodes.findById artist['_id'], (err, docs) ->
    #   if !err
    #     each = docs
    #     each
    #   else
    #     console.log err
    # res.json artist_nodes
  return

exports.import = (req, res) ->
  Artist.create {
    'name': 'Ben'
    'band': 'DJ Code Red'
    'instrument': 'Reason'
  }, (err) ->
    if err
      return console.log(err)
    res.send 202
  return

app.listen 3001, ->
  console.log '%s listening at %s', app.name, app.url
  return

# ---
# generated by js2coffee 2.0.1