
var Coordinates = require('./Coordinates');

groceryItemSchema = new db.Schema({
	Upccode        : String,
	Description    : String,
	POSDescription : String,
	SubCategory    : Number,
	Aisle  		   : String, // created by taking Aisle info from Sobeys and removing shelf id from the end 
	AisleShelf     : String,  // created from full Aisle info from Sobeys
	Coordinates	   : { x: Number, y: Number }
})

groceryItemSchema.methods.setcoordinates = function setcoordinates(cb) {
	console.log('finding coordinates...');

	





	var coordinates = new Coordinates(5,3);

	console.log('Setting Coordinates. x: ' + coordinates.x + ' y: '+coordinates.y);
	this.Coordinates.x = coordinates.x;
	this.Coordinates.y = coordinates.y;
	return this.save(cb);
 }