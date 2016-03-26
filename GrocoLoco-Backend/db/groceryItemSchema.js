
// groceryItemSchema = new db.Schema({
// 	UPC            : String,
// 	Coordinates	   : { x: Number, y: Number },
// 	Category 	   : Number,
// 	Description    : String,  // SOBEYS 
// 	POSDescription : String,  // SOBEYS
// 	SubCategory    : String,  // SOBEYS
// 	Aisle  	       : String,  // SOBEYS - created by taking Aisle info from Sobeys and removing shelf id from the end 
// 	AisleShelf     : String,  // SOBEYS - created from full Aisle info from Sobeys
// 	Position       : String,  // SOBEYS
// 	Width		   : Number,  // SOBEYS
// 	Price		   : Number   // SOBEYS
// })
groceryItemSchema = new db.Schema({
	BlockNumber	   : Number,
	ItemLocation   : Number,
	Face		   : String,
	Shelf		   : Number,
	Category 	   : Number,
	Price		   : Number,   // SOBEYS
	Description    : String,  // SOBEYS 
	Aisle 		   : String,
	StoreId		   : Number,
	IconLink	   : String,
	IsPromo		   : Boolean,
	Promotion 	   :{
		PromoTitle 		: String, 
		PromoDiscount 	: Number,
		Type 			: String,
		PromoStartDate  : Date,
		PromoEndDate 	: Date
	}
})


/*
0 = Produce
1 = Dairy
2 = Deli
3 = Frozen
4 = grains
5 = cans
6 = personal care
7 = bakery
8 = other
*/