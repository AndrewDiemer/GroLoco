
groceryItemSchema = new db.Schema({
	UPC            : String,
	Description    : String,
	POSDescription : String,
	SubCategory    : String,
	Aisle  	       : String,  // created by taking Aisle info from Sobeys and removing shelf id from the end 
	AisleShelf     : String,  // created from full Aisle info from Sobeys
	Position       : String,  // from somewhere on Sobeys end
	Coordinates	   : { x: Number, y: Number }
})