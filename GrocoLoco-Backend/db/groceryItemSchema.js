
groceryItemSchema = new db.Schema({
	UPC            : String,
	Coordinates	   : { x: Number, y: Number },

	Description    : String,  // SOBEYS 
	POSDescription : String,  // SOBEYS
	SubCategory    : String,  // SOBEYS
	Aisle  	       : String,  // SOBEYS - created by taking Aisle info from Sobeys and removing shelf id from the end 
	AisleShelf     : String,  // SOBEYS - created from full Aisle info from Sobeys
	Position       : String,  // SOBEYS
	Width		   : Number   // SOBEYS
})