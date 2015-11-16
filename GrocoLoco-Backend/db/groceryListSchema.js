groceryListSchema = new db.Schema({
	User			: {type: db.Schema.Types.ObjectId, ref: 'User'},
	GroceryListName	: String,
    Date			: { type: Date, default: Date.now },
    List 			: [{
    	UPC            : String,
		Description    : String,
		POSDescription : String,
		SubCategory    : String,
		Aisle  	       : String,  // created by taking Aisle info from Sobeys and removing shelf id from the end 
		AisleShelf     : String,  // created from full Aisle info from Sobeys
		Position       : String,  // from somewhere on Sobeys end
		Coordinates    : { 
	        x        : Number, 
	        y        : Number 
	  	},
	  	Comment       : String
    }]
})

