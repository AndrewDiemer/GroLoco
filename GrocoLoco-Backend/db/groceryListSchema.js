groceryListSchema = new db.Schema({
	User			: {type: db.Schema.Types.ObjectId, ref: 'User'},
	GroceryListName	: String,
    Date			: { type: Date, default: Date.now },
    List 			: [{
    	ItemName    : String,
		Quantity	: Number
    }]
})

