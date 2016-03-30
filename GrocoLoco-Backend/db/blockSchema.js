blockSchema = new db.Schema({ // must be a percentage of width and height of screen in order for outputted coords to also be relative:)
	Store			: {type: db.Schema.Types.ObjectId, ref: 'Store'},
	BlockNumber		: Number,
	Origin: {
		X 			: Number,
		Y 			: Number
	},
	width 			: Number,
	Length 			: Number,
	TopItems 		:[],
	BottomItems 	:[],
	LeftItems 		:[],
	RightItems 		:[]
})
