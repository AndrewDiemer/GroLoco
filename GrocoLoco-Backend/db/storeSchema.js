storeSchema = new db.Schema({
	StoreName 		: String,
	Blocks			: [{type: db.Schema.Types.ObjectId, ref: 'Block'}],
	Longitude		: Number,
	Latitude		: Number,
	Address			: String,
	StoreDimensions	:{
		Unit		: String,
		Length		: Number,
		Width		: Number,
		Ratio		: {
			Description	: String,
			Number		: Number
		}
	}
})