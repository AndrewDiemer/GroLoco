var LocalStrategy   = require('passport-local').Strategy;
var bCrypt = require('bcrypt-nodejs');
var nodemailer = require('nodemailer');

//SMTP EMAIL ============================================
var transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: 'morgan.moskalyk@gmail.com',
        pass: 'Parkhurst#3333'
    }
});

module.exports = function(passport){

	passport.use('signup', new LocalStrategy({
            usernameField : 'Email',
            passwordField : 'Password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },
        function(req, Email, Password, done) {
            console.log('test 1')
            findOrCreateUser = function(){
                console.log('test 2')

                // find a user in Mongo with provided username
                User.findOne({ 'Email' :  Email }, function(err, user) {
                    // In case of any error, return using the done method
                    if (err){
                        console.log('Error in SignUp: '+err);
                        return done(err);
                    }
                    // already exists

                    if (user) {
                        console.log(user)
                        console.log('User already exists with email: '+Email);
                        return done(null, false);
                    } else {
                        // if there is no user with that email
                        // create the user
                        var newUser = new User();

                        // set the user's local credentials
                        newUser.Email       = Email;
                        newUser.Password    = createHash(Password)
                        newUser.Name        = req.param('Name')

                        // save the user
                        newUser.save(function(err, user) {
                            if (err){
                                console.log('Error in Saving user: '+err);  
                                throw err;  
                            }
                            if(user){
                                var mailOptions = {
                                    from: 'morgan@grocoloco.com', // sender address 
                                    to: req.body.Email, // list of receivers 
                                    subject: 'Welcome to GrocoLoco '+user.Name+'!✔', // Subject line 
                                    text: 'Your conformation code is:', // plaintext body 
                                    html: '<h1>This is a personal welcome message from the GrocoLoco Team. </h1> \n <h3>Your confirmation code is: '+user.Password+'</h3>'
                                    // +'Just in case you forgot, your password is: '+ Password
                                };

                                transporter.sendMail(mailOptions, function(error, info){
                                    if(error){
                                        console.log(error);
                                        
                                    }else{
                                        console.log('Message sent: ' + info.response);
                                        // passport.authenticate('local')
                                        
                                    }
                                });

                                console.log('User Registration succesful');    
                                return done(null, newUser);
                            }
                            
                        });
                    }
                });
            };
            // Delay the execution of findOrCreateUser and execute the method
            // in the next tick of the event loop
            process.nextTick(findOrCreateUser);
        })
    );

    // Generates hash using bCrypt
    var createHash = function(password){
        return bCrypt.hashSync(password, bCrypt.genSaltSync(10), null);
    }

}