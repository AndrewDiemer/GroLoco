module.exports = function (app){

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
					Average: sum/ lists.length
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

	//When people make their grocery list (line chart)
	app.get('/timingOfGroceryList', isAuthenticated, function (req, res){

	})

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
