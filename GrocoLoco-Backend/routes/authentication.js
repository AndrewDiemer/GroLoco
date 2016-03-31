
var passport = require('passport')

module.exports = function (app, passport){

    app.post('/createuser', passport.authenticate('signup', {
        successRedirect : '/createuser', // redirect to the secure profile section
        failureRedirect : '/createuser/fail', // redirect back to the signup page if there is an error
        // failureFlash : true // allow flash messages
    }));

    app.get('/createuser', isAuthenticated, function(req,res){
        console.log('testing the sign up')
        res.send(req.user)
    })

    app.get('/createuser/fail', function(req,res){
        var fail = 'Creating a user failed.'
        console.log(fail)
        res.status(500).send({message: fail})
    })

    app.post('/login', passport.authenticate('login', {
        successRedirect : '/home', // redirect to the secure profile section
        failureRedirect : '/login/fail', // redirect back to the signup page if there is an error
        failureFlash : true // allow flash messages
    }));

    app.get('/login/fail', function(req,res){
        var fail = 'Logging in failed.'
        console.log(fail)
        res.status(500).send({message: fail})
    })

    app.get('/home', isAuthenticated, function(req,res){
        res.status(200).send(req.user)
    })

    app.get('/loggedin', isAuthenticated, function(req,res){
        res.send(req.user)
    })

    app.post('/logout', logout, function(req,res){
        res.send({
            status:200,
            message:'bye'
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
    res.status(511)
}
