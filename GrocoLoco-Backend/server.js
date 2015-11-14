var express 		= require('express'),
	app 			= express(),
	helmet			= require('helmet'),
	logger 			= require('morgan'),
	cookieParser 	= require('cookie-parser'),
	bodyParser 		= require('body-parser'),
	compression		= require('compression'),
	port 			= process.env.PORT || 1330,
	expressSession = require('express-session'),
	passport = require('passport'),
	LocalStrategy = require('passport-local').Strategy,
	passportLocalMongoose = require('passport-local-mongoose'),
	flash    = require('connect-flash'),
	methodOverride 	= require('method-override');
	db 				= require('mongoose') //shhh this is global for our schemas

// DATBASE CONFIGS ===================================
db.connect('mongodb://Larry:password@ds051523.mongolab.com:51523/grocery_items', function(err, db) {
    if (err) throw err;
    console.log("Connected to Database");
    _db = db 
})

// EXPRESS CONFIGS ===================================
app.use(compression())
app.use(helmet())
app.use(logger('dev'))
app.use(bodyParser.json()); // get information from html forms
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + '/public'));
app.use('/controllers',express.static(__dirname, 'public/controllers'));
app.use(cookieParser()); 


//PASSPORT ============================================
var initPassport = require('./config/init');
initPassport(passport);

app.use(expressSession({
    // store: new RedisStore({ host: redisHost, port: redisPort, client: client }),
    secret: 'keyboard cat',
    // resave: true,
    cookie: {
        httpOnly: true,
        secure: true
    },
    cookie: { 
        maxAge : 3600000 
    }
}));

app.use(passport.initialize());
app.use(passport.session());

//BROWSER =============================================
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

// SCHEMAS ============================================
require('./db/userSchema.js')
require('./db/groceryItemSchema.js')
require('./db/groceryListSchema.js')

// MODELS =============================================
User = db.model('User', userSchema)
GroceryItem = db.model('GroceryItem', groceryItemSchema)
GroceryList = db.model('GroceryList', groceryListSchema)

//ROUTES ==============================================
require('./routes/routes.js')(app, passport); 

//LISTEN ==============================================
app.listen(port);
console.log('The magic happens on port ' + port);