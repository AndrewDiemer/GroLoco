

module.exports = function (app){
	 app.get('/userlocation', isAuthenticated, function(req, res){
        User.findOneAndUpdate({
            'Email': req.user.Email
        }, function(err, user){
            if(err)
                res.send(err)
            if(user){
                var location = {
                    StoreName   : user.StoreName,
                    Latitude    : user.Latitude,
                    Longitude   : user.Longitude
                }

                res.send(location)
            }
            else
                res.send(404)
        })
    })

    app.post('/setuserlocation', isAuthenticated, function(req,res){
        User.findOneAndUpdate({
            'Email': req.user.Email
        },{
            StoreName   : req.body.StoreName,
            Latitude    : req.body.Latitude,
            Longitude   : req.body.Longitude
        }, function(err, user){
            if(err)
                res.send(err)
            if(user)
                res.send(user)
            else
                res.send(404)
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
    res.send({'status': false});
}
