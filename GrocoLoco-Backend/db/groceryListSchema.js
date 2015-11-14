groceryListSchema = new db.Schema({
	User			: {type: db.Schema.Types.ObjectId, ref: 'User'},
	GroceryListName	: String,
    Date			: { type: Date, default: Date.now },
    List 			: [{
    	CrossedOut	: { type: Boolean, default: false },
    	ItemName    : String,
		Quantity	: Number,
		Comment		: String
    }]
})

