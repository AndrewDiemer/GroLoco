

module.exports = function (app){
	 app.get('/userlocation', isAuthenticated, function(req, res){
        User.findOneAndUpdate({
            'Email': req.user.Email
        }, function(err, user){
            if(err)
                res.send(err)
            if(user){
                var location = {
                    StoreName   : user.StoreName
                }

                res.send(location)
            }
            else
                res.send(404)
        })
    })

    app.post('/setuserlocation', isAuthenticated, function(req,res){
        Store.findOne({
            '_id': req.body._id
        }, function(err, store){
            if(err)
                res.send(err)
            if(store){
                User.findOneAndUpdate({
                    'Email': req.user.Email
                },{
                    StoreName   : req.body.StoreName,
                    Store       : store
                }, function(err, user){
                    if(err)
                        res.send(err)
                    if(user)
                        res.send(user)
                    else
                        res.send(404)
                })
            }else{
                res.send(404)
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
