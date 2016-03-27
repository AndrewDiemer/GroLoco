module.exports = function (app){


    app.post('/createGroceryItem', isAuthenticated, function (req, res){

//TODO: Figure out my Promotions is not being saved in the DB.
		var newItem = new GroceryItem({

			Category       : req.body.Category,
			Price          : req.body.Price,   
			Description    : req.body.Description,   
			IconLink 	   : req.body.IconLink,
			Promotion  	   : {},
			IsPromo		   : false
		});

		newItem.save(function (err) {
		 if (err){ 
		 	console.log(err);
		 	res.send(err);
		 } 
		 else{	 	
		 	res.send(200);
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
