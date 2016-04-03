

module.exports = function (app){

    app.get('/promoHacks', isAuthenticated, function(req,res){
        GroceryItem.find({}, function(err, items){
            for (var i = 0; i < items.length; i++) {
                if(items[i].IsPromo == false){
                    GroceryItem.findOneAndUpdate({
                        '_id': items[i]._id
                    },{
                        'Promotion': {}
                    }, function(err, items){
                        if(err)
                            console.log(err)
                        if(items)
                            console.log('updated')
                        else
                            console.log('could not find')
                    })
                }
            }
            res.send(200)
        })
    })

    app.post('/addPromo', isAuthenticated, function(req, res){

        var promotion = {
            PromoTitle      : req.body.PromoTitle, 
            PromoDiscount   : req.body.PromoDiscount,
            Type            : req.body.Type,
            PromoStartDate  : req.body.PromoStartDate,
            PromoEndDate    : req.body.PromoEndDate
        }

        GroceryItem.findOneAndUpdate({
            '_id' : req.body._id
        },{
            'Promotion' : promotion,
            'IsPromo'   : req.body.IsPromo
        },{
            safe:true, upsert:true, new: true
        }, function(err, groceryItem){
            if(err)
                res.send(err)
            if(groceryItem){
                res.status(200).send(groceryItem)
            }else{
                res.send(404)
            }
        })

    })

    app.post('/removePromo', isAuthenticated, function(req,res){

        GroceryItem.findOneAndUpdate({
            '_id': req.body._id
        },{
            Promotion:{},
            IsPromo: false
        }, function(err, groceryItem){
            if(err)
                res.send(err)
            if(groceryItem){
                res.send(groceryItem)
            }
            else
                res.send(404)
        })
    })


    app.get('/groceries', isAuthenticated, function(req,res){
        GroceryItem.find({}, function(err, items){
            if(err)
                res.send(err)
            if(items)
                res.send(items)
            else
                res.send([])
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
    res.send(511)
    
}
