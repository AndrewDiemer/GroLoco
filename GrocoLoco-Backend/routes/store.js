

module.exports = function (app){

	app.get('/stores', function(req,res){
		Store.find({},function(err,stores){
			if(err)
				res.send(err)
			if(stores)
				res.send(stores)
			else
				res.status(404).send([])
		})
	})

	app.get('/updateStores', function(req, res){
		Store.findOne({
			StoreName: 'Sobeys'
		}, function(err, store){
			Block.find({}, function(err, blocks){
				for (var i = 0; i < blocks.length; i++) {
					Block.findOneAndUpdate({
						'_id': blocks[i]._id
					},{
						'Store': store
					}, function(err, store){
						if(err)
							res.send(err)
						if(store){
							// res.send(store)
						}else{
							res.send(404)
						}
						// else
							// 
					})
				}
				res.send(200)
			})
		})
	})

	//Create a store and set the dimension
	app.post('/createstore', function (req,res){
		var newStore = new Store({
			StoreName 		: req.body.StoreName,
			Longitude		: req.body.Longitude,
			Latitude		: req.body.Latitude,
			Address 		: req.body.Address,
			StoreDimensions	:{
				Unit		: 'metre',
				Length		: req.body.Length,
				Width		: req.body.Width,
				Ratio		: {
					Description	: 'Length / Width',
					Number		: req.body.Length / req.body.Width
				}
			}
		})

		newStore.save(function(err, store){
			if(err)
				res.send(err)
			if(store){
				console.log(store)
				res.send(store)
			}
		})
	})

	//Assign blocks to existing store
	app.post('/assignblocks', isAuthenticated, function (req,res){
		Block.find({}, function (err, blocks){
			if(err)
				res.send(err)
			if(blocks){
				Store.findOneAndUpdate({
					StoreName: req.body.StoreName
				},{
					'Blocks': blocks
				}, function(err, store){
					if(err)
						res.send(err)
					if(store)
						res.send(store)
					else
						res.send(404)
				})
			}else{
				res.send({
					status: 404,
					message: 'No blocks'
				})
			}
		})
	})

	//This is more of a one time route, in order to migrte all users to store. Poor design morgan.
	app.post('/assignallusers', isAuthenticated, function (req,res){
		Store.findOne({
			'StoreName' : req.body.StoreName
		},function (err, store){
			if(err)
				res.send(err)
			if(store){
				User.find({}, function (err, users){
					if(users){
						for (var i = 0; i < users.length; i++)
							User.findOneAndUpdate({
								'_id':users[i]._id
							},{
								Store: store
							}, function(err, user){
								if(err)
									res.send(err)
								if(user)
									console.log(user)
							})
						res.send(200)
					}else{
						res.send(404)
					}
				})
			}else{
				res.send('Could not find store')
			}
		})
	})
}

var isAuthenticated = function (req, res, next) {
    // if user is authenticated in the session, call the next() to call the next request handler 
    // Passport adds this method to request object. A middleware is allowed to add properties to
    // request and response object
    if (req.isAuthenticated()){
        console.log('User is authenticated')
        return next();
    }
    // if the user is not authenticated then redirect him to the login page
    var fail = 'Sorry a user is not logged in'
    console.log(fail)
    res.status(511)
}