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
    RedisStore = require('connect-redis')(expressSession)
    redis = require('redis')

//REDIS ===============================================
var redisPort = 6379
var redisHost = '127.0.0.1'

client = redis.createClient('redis://h:ptbc0r5lerem2cfuvsnc06b0bc@ec2-54-225-195-114.compute-1.amazonaws.com:12999')
// client = redis.createClient(redisPort, redisHost)

client.on('connect', function() {
    console.log('Connected to Redis');
});

client.on("error", function (err) {
        console.log("Error " + err)
    });

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
    store: new RedisStore({ host: redisHost, port: redisPort, client: client }),
    secret: 'keyboard cat',
    // resave: true,
    cookie: {
        httpOnly: true,
        secure: true
    },
    cookie: { 
        maxAge : 3600000*3 
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
require('./db/aisleSchema.js')
require('./db/blockSchema.js')
require('./db/storeSchema.js')
require('./db/itemWidthSchema.js')
require('./db/iconImageSchema.js')
require('./db/groceryItemSchema.js')
require('./db/groceryListSchema.js')
require('./db/blockCoordinatesSchema.js')

// MODELS =============================================
User = db.model('User', userSchema)
Aisle = db.model('Aisle', aisleSchema)
Store = db.model('Store', storeSchema)
Icon = db.model("IconImage", iconImageSchema);
Block = db.model("Block", blockSchema);
ItemWidth = db.model('ItemWidth', itemWidthSchema)
GroceryItem = db.model('GroceryItem', groceryItemSchema)
GroceryList = db.model('GroceryList', groceryListSchema)
BlockCoordinates = db.model('BlockCoordinates', blockCoordinatesSchema)

//ROUTES ==============================================
require('./routes/routes.js')(app, passport); 
require('./routes/twilio.js')(app); 
require('./routes/store.js')(app, passport); 
require('./routes/promotions.js')(app, passport); 
require('./routes/groceryList.js')(app, passport); 
require('./routes/user.js')(app, passport); 
require('./routes/authentication.js')(app, passport); 
require('./routes/analytics.js')(app, passport); 
require('./routes/groceryManager.js')(app, passport); 
require('./routes/blocks.js')(app, passport); 
require('./routes/recommendations.js')(app, passport); 

//CREATE DATA ====================================
var createData = require('./createData/CreateData.js');
createData();

// STORE ICON IMAGES IN THE DB
var saveImages = require('./SaveImages');
saveImages();

//LISTEN ==============================================
app.listen(port);
console.log('The magic happens on port ' + port);

