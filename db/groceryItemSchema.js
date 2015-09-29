groceryItem = new db.Schema({
	ItemName    : String,
	SKU        	: Number,
    LocationID  : Number,
    Date		: { type: Date, default: Date.now }
})

