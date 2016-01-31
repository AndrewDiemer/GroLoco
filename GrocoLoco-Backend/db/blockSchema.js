blockSchema = new db.Schema({ // must be a percentage of width and height of screen in order for outputted coords to also be relative:)
	BlockNumber		: Number,
	Origin: {
		X 			: Number,
		Y 			: Number
	},
	width 			: Number,
	Length 			: Number,
	TopItems 		:[{type: db.Schema.Types.ObjectId, ref: 'GroceryItem'}],
	BottomItems 	:[{type: db.Schema.Types.ObjectId, ref: 'GroceryItem'}],
	LeftItems 		:[{type: db.Schema.Types.ObjectId, ref: 'GroceryItem'}],
	RightItems 		:[{type: db.Schema.Types.ObjectId, ref: 'GroceryItem'}]
})
