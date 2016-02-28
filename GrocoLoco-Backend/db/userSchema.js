userSchema = new db.Schema({
	Name 					: String,
	Email       			: String,
	Password    			: String,
	RegistrationDate		: { type: Date, default: Date.now },
	GroceryList				: [{type: db.Schema.Types.ObjectId, ref: 'GroceryList'}],
	StoreName				: String,
	Store 					: {type: db.Schema.Types.ObjectId, ref: 'Store'}
})

