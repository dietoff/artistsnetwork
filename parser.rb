require 'crack'
require 'mongo'

db   = Mongo::Connection.new.db('bios')
col  = db.collection('scratch')

data = open("final.xml").read

data = Crack::XML.parse(data)

col.save(data['PDBdescription']['PDB'])
col.save(data["data"]["bio"]["name"])
