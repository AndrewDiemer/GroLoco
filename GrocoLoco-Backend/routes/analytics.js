module.exports = function (app){

	app.get('/usersOverTime', isAuthenticated, function(req,res){
		// User.find({}, function())
	})

	//Average Grocerylist size (Number)
	app.get('/averageGrocerySize', isAuthenticated, function (req, res){
		GroceryList.find({}, function(err, lists){
			if(err)
				res.send(err)
			if(lists){
				var sum = 0;
				for (var i = 0; i < lists.length; i++)
					sum += lists[i].List.length
				res.send({
					Average: sum / lists.length
				})
			}else
				res.send(0)
		})
	})

	//Average Grocerylist size (Number)
	app.get('/averageGrocerySizeDistribution', isAuthenticated, function (req, res){
		
		var distribution = []

		GroceryList.find({}, function(err, lists){
			if(err)
				res.send(err)
			if(lists){
				for (var i = 0; i < lists.length; i++){
					if(distribution.hasOwnProperty(lists[i].List.length)){
						distribution[lists[i].List.length] ++
					}else{
						distribution[lists[i].List.length] = 1
					}
				}

				var keys = Object.keys(distribution)
				var dataSize = parseInt(keys[keys.length - 1])

				for (var i = 0; i < dataSize; i++) {
					if(!distribution.hasOwnProperty(String(i))) {
						distribution[i] = 0
					}
				}

				res.send({
					Distrubition: distribution
				})
			}else
				res.send(0)
		})
	})

	//Number from each category (pie graph)
	app.get('/numberPerCategory', isAuthenticated, function (req, res){
		GroceryList.find({}, function(err, lists){
			if(err)
				res.send(err)
			if(lists){

				var categories = {
					Produce: 0,
					Dairy: 0,
					Deli: 0,
					Frozen: 0,
					Grains: 0,
					Cans: 0,
					PersonalCare: 0,
					Bakery: 0,
					Other: 0
				}

				for (var i = 0; i < lists.length; i++){
					console.log(lists[i])
					switch(lists[i].Category) {
					    case 0:
					        categories.Produce++
					        break;
					    case 1:
					        categories.Dairy++
					        break;
					    case 2:
					        categories.Deli++
					        break;
					    case 3:
					        categories.Frozen++
					        break;
					    case 4:
					        categories.Grains++
					        break;
					    case 5:
					        categories.Cans++
					        break;
					    case 6:
					        categories.PersonalCare++
					        break;
					    case 7:
					        categories.Bakery++
					        break;
					    default:
					        categories.Other++
					}
				}
				res.send({
					Categories: categories
				})
			}else
				res.send(0)
		})
	})

	// //When people make their grocery list (line chart)
	// app.get('/timingOfGroceryList', isAuthenticated, function (req, res){

	// })

	//Frequency of items purchased
	app.get('/frequenciesOfItems', isAuthenticated, function (req, res){
		GroceryList.find({}, function(err, list){
			var dict = {}
			for (var j = 0; j < list.length; j++) {
				for (var i = 0; i < list[j].List.length; i++) {
					if(typeof list[j].List[i].Description != "undefined"){
						if(dict.hasOwnProperty(list[j].List[i].Description)){
							dict[list[j].List[i].Description]++
						}else{
							dict[list[j].List[i].Description] = 0
						}
					}
				}
			}

			res.send(dict)
		})
	})

	//When people make their groceyr list (line chart)
	app.get('/numberOfUsers', isAuthenticated, function (req, res){
		User.find({}, function(err, users){
			if(err)
				res.send(err)
			if(users)
				res.send({Number: users.length})
			else
				res.send({Number: 0})
		})
	})

	app.get('/getRecommendationBreakdown', isAuthenticated, function (req,res){
		GroceryList.find({}, function(err, grocerylists){
			if(err){
				res.send(err)
			}if(grocerylists){
				var recommendationBreakdowns = []
				var reccommendCount = 0
				//Itereate through each grocerylist
				for (var i = 0; i < grocerylists.length; i++) {
					reccommendCount = 0
					if(grocerylists[i].List.length > 0){
						for (var j = 0; j < grocerylists[i].List.length; j++) {
							if(grocerylists[i].List[j].Recommended)
								reccommendCount++
						}
						recommendationBreakdowns.push(reccommendCount / grocerylists[i].List.length)
					}else{
						recommendationBreakdowns.push(0)
					}
				}
				var ranges = {
					0.1: 0,
					0.2: 0,
					0.3: 0,
					0.4: 0,
					0.5: 0,
					0.6: 0,
					0.7: 0,
					0.8: 0,
					0.9: 0,
					1.0: 0
				}
				console.log(recommendationBreakdowns)
				for (var i = 0; i < recommendationBreakdowns.length; i++) {

					var dat = recommendationBreakdowns[i]

					if(dat >= 0 && dat <= 0.1){
						ranges['0.1'] ++
					}else if(dat > 0.1 && dat <= 0.2){
						ranges['0.2'] ++
					}else if(dat > 0.2 && dat <= 0.3){
						ranges['0.3'] ++
					}else if(dat > 0.3 && dat <= 0.4){
						ranges['0.4'] ++
					}else if(dat > 0.4 && dat <= 0.5){
						ranges['0.5'] ++
					}else if(dat > 0.5 && dat <= 0.6){
						ranges['0.6'] ++
					}else if(dat > 0.6 && dat <= 0.7){
						ranges['0.7'] ++
					}else if(dat > 0.7 && dat <= 0.8){
						ranges['0.8'] ++
					}else if(dat > 0.8 && dat <= 0.9){
						ranges['0.9'] ++
					}else if(dat > 0.9 && dat <= 1.0){
						ranges['1.0'] ++
					}
				}

				res.send({RecommendationBreakdownList: ranges})

			}else{
				res.send(404)
			}
		})
	})

	//Of all the items added to the grocery list, get the % that are from recommended
	app.get('/getRecommendationTotal', isAuthenticated, function(req,res){
		GroceryList.find({}, function(err, grocerylists){
			if(err){
				res.send(err)
			}if(grocerylists){
				var recommendationBreakdowns = []
				var reccommendCount = 0
				var groceryItemCount = 0
				//Itereate through each grocerylist
				for (var i = 0; i < grocerylists.length; i++) {
					if(grocerylists[i].List.length > 0){
						for (var j = 0; j < grocerylists[i].List.length; j++) {
							if(grocerylists[i].List[j].Recommended)
								reccommendCount++
							groceryItemCount++
						}
					}
				}
				res.send({TotalBreakdown: reccommendCount / groceryItemCount})

			}else{
				res.send(0)
			}
		})
	})
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
