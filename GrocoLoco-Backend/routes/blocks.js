var _ = require('lodash')

module.exports = function (app, passport){


	app.get('/populateTestBlock', isAuthenticated,function(req,res){
		console.log('test')
		GroceryItem.find({
			'BlockNumber': 0,
			'Face':'R'
		}, function(err, groceries){
			if(err)
				res.send(err)
			if(groceries){
				for (var i = 0; i < groceries.length;i++){

					Block.findOneAndUpdate({
			            'BlockNumber': 0
			        },{
		                $push:{'RightItems': groceries[i]}
		            },{
		                safe:true, upsert:true, new: true
		            }, function(err, block){
			            if(err)
			                res.send(err)
			            if(block){
			                res.send(block)
			            }
			            else
			                res.send(404)
			        })

				}
			}else{	
				res.send(404)
			}
		})
	})


	app.get('/whatsa', isAuthenticated,function(req,res){
		GroceryItem.find({
			Description: 'apples'
		}, function(err, items){
			if(err)
				res.send(err)
			if(items){

				for (var i = 0; i < items.length; i++) {
					res.send(items[i].POSDescription)
					break;
					// if(items[i].POS==){
					// 	res.send(items.POS)
					// }else{
					// 	res.send('shit')
					// }
				};
			
			}
		})
	})

	//Create Block
	app.post('/block', isAuthenticated, function (req, res){
		// var blockNumbes = [0,1,2,3,4,5,6,7,8]
		// for (var i = 0; i < Things.length; i++) {
		// 	Things[i]
		// };

		// var = blockList[]


		var newBlock = new Block({
			BlockNumber		: 0,
			Origin: {
				X 			: 0.01,
				Y 			: 0.2
			},
			width 			: 0.1,
			Length 			: 0.7
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 1,
			Origin: {
				X 			: 0.13,
				Y 			: 0.05
			},
			width 			: 0.8,
			Length 			: 0.1
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 2,
			Origin: {
				X 			: 0.9,
				Y 			: 0.2
			},
			width 			: 0.1,
			Length 			: 0.7
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 3,
			Origin: {
				X 			: 0.5,
				Y 			: 0.9
			},
			width 			: 0.35,
			Length 			: 0.1
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 4,
			Origin: {
				X 			: 0.22,
				Y 			: 0.67
			},
			width 			: 0.2,
			Length 			: 0.1
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 5,
			Origin: {
				X 			: 0.22,
				Y 			: 0.45
			},
			width 			: 0.2,
			Length 			: 0.1
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 6,
			Origin: {
				X 			: 0.22,
				Y 			: 0.24
			},
			width 			: 0.2,
			Length 			: 0.1
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 7,
			Origin: {
				X 			: 0.53,
				Y 			: 0.24
			},
			width 			: 0.1,
			Length 			: 0.53
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})


		var newBlock = new Block({
			BlockNumber		: 8,
			Origin: {
				X 			: 0.73,
				Y 			: 0.24
			},
			width 			: 0.1,
			Length 			: 0.53
		})

		newBlock.save(function(err, block){
			if(err)
				res.send(err)
				// res.send(block)
		})

		res.send(200)


	})

	app.get('/blocks', function (req,res){
		Block.find({}, function (err, blocks){
			res.send(blocks)
		})
	})

	app.post('/updateGroceryItem', function(req,res){
		GroceryItem.findOneAndUpdate({
			'Description': req.body.Description
		},{
			Face: req.body.Side,
			ItemLocation: req.body.Distance,
			BlockNumber: req.body.BlockNumber
		}, function(err, groceryItem){
			if(err)
				res.send(err)
			if(groceryItem){
				//Update in all the grocery lists
				GroceryList.find({}, function(err, groceryLists){
					if(err)
						res.send(err)
					if(groceryLists){
						for (var i = 0; i < groceryLists.length; i++) {
							for (var j = 0; j< groceryLists[i].List.length; j++) {
								
								if(groceryLists[i].List[j].Description == req.body.Description){

									groceryLists[i].List[j].Face = req.body.Side
									groceryLists[i].List[j].ItemLocation = req.body.Distance
									groceryLists[i].List[j].BlockNumber = req.body.BlockNumber

									GroceryList.findOneAndUpdate({
										'_id': groceryLists[i]._id
									},{
										List: groceryLists[i].List[j]
									},function(err, list){
										if(err)
											res.send(err)
										if(list)
											console.log('Updated')
										// console.log()
									})
								}
							}
						}
					}else{
						res.send(404)
					}
				})

				res.send(groceryItem)
			}
			else
				res.send(404)
		})
	})

	app.get('/blockItems/:store/:block', isAuthenticated, function(req,res){
		// console.log()
		Block.findOne({
			'Store': req.params.store,
			'BlockNumber': req.params.block
		}, function(err, block){
			if(err)
				res.send(err)
			if(block){
				GroceryItem.find({
					'StoreId': 1,
					'BlockNumber': req.params.block
				}, function(err, groceries){
					if(err)
						res.send(err)
					if(groceries){
						for (var i = 0; i < groceries.length; i++){
							// console.log(groceryList.List[i].StoreId)
							if(req.user.Store != '56b01bf96b0aa47e3b17e9e2'){
								console.log('oops')
							}else{
								console.log(groceries[i].Face)
								switch(groceries[i].Face){
									case 'T':
										block.TopItems.push(groceries[i])
										break

									case 'B':
										block.BottomItems.push(groceries[i])
										break
									
									case 'L':
										block.LeftItems.push(groceries[i])
										break
								
									case 'R':
										block.RightItems.push(groceries[i])
										break
									default:
										break
								}
							}
						}
						// console.log(block)
						res.send(_.union(block.TopItems, block.BottomItems, block.LeftItems, block.RightItems))
					}else{
						res.send(404)
					}
						

				})
				// res.send(block)
			}else
				res.send(404)

		})
	})


	app.get('/blocks/:id', function (req,res){
		console.log(req.params.id)
		Store.findOne({
			'_id': req.params.id
		}, function(err, store){
			if(err)
				res.send(err)
			if(store){
				console.log(store)
				Block.find({
					'Store': store
				}, function (err, blocks){
					if(err)
						res.send(blocks)
					if(blocks){
						var package = {
							Store: store,
							Blocks: blocks
						}
						res.send(package)
					}
					else
						res.send(404)
				})
			}
		})
	})

	app.get('/blocksGroceryList', isAuthenticated, function (req,res){
		//Get the Blocks

		//Get the Users Grocery list

		//Get the items in the Groceyr list

		//Assign those grocery items to the blocks, based on the right block and side
		Store.findOne({
			'_id': req.user.Store
		}, function(err, store){
			if(err)
				res.send(err)
			if(store){
				console.log(store)
				// res.send(store.Blocks)
				Block.find({
					'_id': { $in: store.Blocks}
				}, function(err,blocks){
					if(err)
						res.send(err)
					if(blocks){
						GroceryList.findOne({
							'_id' : req.user.GroceryList[0]
						}, function(err, groceryList){
							if(err)
								res.send(err)
							if(groceryList){
								
								for (var i = 0; i < groceryList.List.length; i++){
									// console.log(groceryList.List[i].StoreId)
									// if(req.user.Store != '56b01bf96b0aa47e3b17e9e2'){
									// 	console.log('oops')
									// }else{
										console.log(groceryList.List[i].Face)
										switch(groceryList.List[i].Face){
											case 'T':
												if(typeof blocks[groceryList.List[i].BlockNumber] != 'undefined')
													blocks[groceryList.List[i].BlockNumber].TopItems.push(groceryList.List[i])
												break

											case 'B':
												if(typeof blocks[groceryList.List[i].BlockNumber] != 'undefined')
													blocks[groceryList.List[i].BlockNumber].BottomItems.push(groceryList.List[i])
												break
											
											case 'L':
												if(typeof blocks[groceryList.List[i].BlockNumber] != 'undefined')
													blocks[groceryList.List[i].BlockNumber].LeftItems.push(groceryList.List[i])
												break
										
											case 'R':
												if(typeof blocks[groceryList.List[i].BlockNumber] != 'undefined')
													blocks[groceryList.List[i].BlockNumber].RightItems.push(groceryList.List[i])
												break
											default:
												break
										}
									// }
								}
								var map = {
									StoreDimensions: store.StoreDimensions,
									Blocks: blocks
								}
								console.log(map)
								res.send(map)
							}else{
								res.send({
									status: 404,
									message: 'Cannot find GroceryList!'
								})
							}
						})
					}else{
						res.send({
							status: 404,
							message: 'There are no blocks.'
						})
					}
				})
			}else{
				res.status(404).send("Store not found. :(")
			}
		})

		
	})

	app.get('/aisles', function(req,res){
        Aisle.find({}, function(err, aisles){
            if(err)
                res.send(err)
            if(aisles){
                res.send(aisles)
            }else{
                res.send(404)
            }
        })
    })

    app.post('/deleteblocks', function(req,res){
        Aisle.collection.remove()
        res.send(200)
    })

    app.post('/blocks', function(req,res){
    	var blocks = req.body.blocks
        var storeId = req.body.storeId
        
        console.log(blocks)
        console.log(storeId)

        Store.findOne({
        	'_id': storeId
        }, function(err, store){
        	if(err)
        		res.send(err)
        	if(store){
        		for (var i = 0; i < blocks.length; i++) {
		    		var newBlock = new Block({
						BlockNumber		: i,
						Origin: {
							X 			: blocks[i].x,
							Y 			: blocks[i].y
						},
						width 			: blocks[i].w,
						Length 			: blocks[i].h,
						Store 			: store
					})

					newBlock.save(function(err, block){
						if(err)
		                    res.send(err)
		                if(block){

		                    Store.findOneAndUpdate({
		                    	'_id': storeId
		                    },{
		                    	$push:{'Blocks': block}
		                    },function(err, store){
		                    	if(err)
		                    		res.send(err)
		                    	if(store)
		                    		console.log(store)
		                    })
		                }else{
		                    res.send(404)
		                }
					})
		    	}

		    	res.send(200)
        	}
        })

    	

    })

    // app.post('/aisles', function(req,res){
        

    //     for (var i = 0; i < blocks.length; i++) {
    //         var newBlock = new Block({
    //             x: blocks[i].x,
    //             y: blocks[i].y,
    //             w: blocks[i].w,
    //             h: blocks[i].h
    //         })

    //         newBlock.save(function(err, block){
                
    //         })
    //     }
    //     console.log('Saved '+ blocks.length + ' blocks!')
    //     res.send('Saved '+ blocks.length + ' blocks!')
    // })

    app.post('/getIcon', function(req,res){

        Icon.find({}, function(err, icons){
            if(err)
                res.send(err);
            if(icons) {
                for(var i=0; i< icons.length; i++){
                    if(icons[i].Name == req.body.Name){
                        res.send(icons[i])
                        break;
                    }
                }
            } else
                res.send(404)
            })
    })

    app.get('/itemcoordinates', function(req, res){ // app.get('/itemcoordinates', isAuthenticated, function(req, res){      
        GroceryItem.findOne({
            'UPC': req.query.UPC
        }, function(err, item){
            if(err)
                res.send(err);
            if(item) {
                // found item, now need to get and set its coordinates
                if(item.Coordinates) {
                    console.log('SUCCESS - found and returned coordinates');                    
                    res.send(item.Coordinates);
                } else {
                    console.log('ERROR - no coordinates found for this item!');                    
                    var coord = {x : 5, y : 5};
                    res.send(coord);
                }
            }
        })
    });
}


var logout = function(req, res, next){
    req.logout()
    req.session.destroy();
    return next()
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
    res.send({'status': false});
}

