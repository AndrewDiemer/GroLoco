
blockCoordinatesSchema = new db.Schema({ // must be a percentage of width and height of screen in order for outputted coords to also be relative:)
	UPC : String,
	x1  : Number,
	y1  : Number,
	x2  : Number,
	y2  : Number
})