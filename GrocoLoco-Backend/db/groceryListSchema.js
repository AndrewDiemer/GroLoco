groceryListSchema = new db.Schema({
	User			: {type: db.Schema.Types.ObjectId, ref: 'User'},
	GroceryListName	: String,
    Date			: { type: Date, default: Date.now },
    List 			: [{
        Recommended     : Boolean,
    	BlockNumber	  	: Number,
    	ItemLocation   	: Number,
    	Face 		   	: String,
    	Shelf 			: Number,
    	Category 		: Number,
    	Price 			: Number,
    	Description 	: String,
    	Aisle 			: String,
    	StoreId 		: Number,
    	IconLink 		: String,
    	Comment 		: String,
    	Date			: { type: Date, default: Date.now },
        IsPromo         : Boolean,
        Promotion       :{
            PromoTitle      : String, 
            PromoDiscount   : Number,
            Type            : String,
            PromoStartDate  : Date,
            PromoEndDate    : Date
        }

  //   	UPC            : String,
		// Description    : String,
		// POSDescription : String,
		// SubCategory    : String,
		// Aisle  	       : String,  // created by taking Aisle info from Sobeys and removing shelf id from the end 
		// AisleShelf     : String,  // created from full Aisle info from Sobeys
	 //  	Comment       : String,
	  	
    }]
})

