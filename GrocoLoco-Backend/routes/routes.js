var _ = require('lodash')
var clone = require('clone')
var passport = require('passport')
var testSet = require('../machinelearningdata/testSet.js')
var request = require('request')

//ROUTES ===========================================================

module.exports = function (app){

    app.get('/populatedatabase', isAuthenticated, function(req,res){
        for (var i = 0; i < testSet.length; i++) {
            var newItem = new GroceryItem({
                BlockNumber    : testSet[i].BlockNumber,
                ItemLocation   : testSet[i].ItemLocation,
                Face           : testSet[i].Face,
                Shelf          : testSet[i].Shelf,
                Category       : testSet[i].Category,
                Price          : testSet[i].Price,   // SOBEYS
                Description    : testSet[i].Description,  // SOBEYS 
                Aisle          : testSet[i].Aisle,
                StoreId        : testSet[i].StoreId,
                IconLink       : testSet[i].IconLink
            });
            
            newItem.save(function (err) { if (err) console.log(err); })
        }
        res.send(testSet)
    })

    /*
        work in progress
        -morgan
    */ 

    // app.get('/finditemsasync/:subsearch', isAuthenticated, function(req, res){
    //     var itemList = []
    //     var subSearch = req.params.subsearch

    //     var time_1 = Date.now()
    //     var time_2 = 0
    //     var total_time = 0

    //     var redisQuery = 'autocomplete/' + subSearch
    //     // console.log(redisQuery)

    //     client.get(redisQuery, function(err, data){
    //         if(err)
    //             res.send(err)
    //         if(data){
    //             time_2 = Date.now()
    //             total_time = time_2-time_1
    //             // console.log('Time to retrieve using Redis: ' + total_time+'ms')
    //             res.send(JSON.parse(data))
    //         }else{
    //             GroceryItem.find({}, function(err, groceryitems){
    //                 if(err)
    //                     res.send(err)
    //                 if(groceryitems){
    //                     var itemList = [];
    //                     for(var i = 0; i < groceryitems.length; i++){

    //                         //check the description
    //                         async.parallel([
    //                             function(callback){
    //                                 if(groceryitems[i].Description){
    //                                     var descriptionListOfWords = groceryitems[i].Description.split(' ')
    //                                     console.log(descriptionListOfWords.length)
    //                                     for (var j = 0; j < descriptionListOfWords.length; j++) {                            
    //                                         if(descriptionListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
    //                                             // itemList.push(groceryitems[i])
    //                                             console.log('yes')

    //                                             callback(null, groceryitems[i])
    //                                             break;
    //                                         }
    //                                     }
    //                                     // callback(null)

    //                                 }
    //                             },
    //                             function(callback){
    //                                 if(groceryitems[i].POSDescription){
    //                                     var POSDescriptionListOfWords = groceryitems[i].POSDescription.split(' ')
    //                                     console.log(POSDescriptionListOfWords.length)

    //                                     for (var j = 0; j < POSDescriptionListOfWords.length; j++) {                            
    //                                         if(POSDescriptionListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
    //                                             // itemList.push(groceryitems[i])
    //                                             console.log('yes')

    //                                             callback(null,groceryitems[i])
    //                                             break;
    //                                         }
    //                                     }
    //                                     // callback(null)

    //                                 }
    //                             },
    //                             function(callback){
    //                                 if(groceryitems[i].SubCategory){
    //                                     console.log('what')
    //                                     var subCategoryListOfWords = groceryitems[i].SubCategory.split(' ')
    //                                     console.log(subCategoryListOfWords.length)
    //                                     for (var j = 0; j < subCategoryListOfWords.length; j++) {                            
    //                                         if(subCategoryListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
    //                                             // itemList.push(groceryitems[i])
    //                                             console.log('yes')
    //                                             callback(null,groceryitems[i])
    //                                             break;
    //                                         }
    //                                     }
    //                                     // callback(null)
    //                                 }
    //                             }
    //                         ],
    //                         // optional callback
    //                         function(err, results){
    //                             if(err)
    //                                 res.send(err)
    //                             console.log('results')
    //                             console.log(results)

    //                             var items = _.union(results)
                                
    //                             itemList.push(items)
    //                             if(i== groceryitems.length-1){
    //                                 res.send(itemList)
    //                                 client.set(redisQuery, JSON.stringify(itemList))
    //                             }
    //                         });
                            
    //                     }

                        

    //                     time_2 = Date.now()
    //                     total_time = time_2-time_1
                        
    //                     // console.log('Time to retrieve using MongoDB: ' + total_time+'ms')
                        
    //                 }
    //                 else
    //                     res.send(404)
    //            })
    //         }
    //     })
    // });  
    
    // deprecated
    // app.post('/crossoutitem', isAuthenticated, function(req, res){
    //     GroceryList.findOne({
    //         'User': req.user,
    //         'GroceryListName': req.body.GroceryListName
    //     }, function(err, groceryList){
    //         if(err)
    //             res.send(err)
    //         if(groceryList){
    //             for(var i = 0; i < groceryList.List.length; i++){
    //                 if(groceryList.List[i]._id == req.body._id){
    //                     groceryList.List[i].CrossedOut = req.body.CrossedOut
    //                      GroceryList.findOneAndUpdate({
    //                         'User': req.user,
    //                         'GroceryListName': req.body.GroceryListName
    //                     },{
    //                         'List': groceryList.List
    //                     },{
    //                         safe:true, upsert:true, new: true
    //                     },
    //                     function(err, groceryList){
    //                         if(err)
    //                             res.send(err)
    //                         if(groceryList)
    //                             res.send(groceryList)
    //                     })
    //                 }
    //             }
    //         }else{
    //             res.send(404);
    //         }
    //     })
    // })

    
    //Deprecated
    // app.post('/editgroceryitem', isAuthenticated, function(req, res){
    //     GroceryList.findOne({
    //             'User': req.user,
    //             'GroceryListName': req.body.GroceryListName
    //         }, function(err, groceryList){
    //             if(err)
    //                 res.send(err)
    //             if(groceryList){
    //                 for(var i = 0; i < groceryList.List.length; i++){
    //                     if(groceryList.List[i]._id == req.body._id){
    //                         groceryList.List[i].ItemName = req.body.ItemName
    //                         groceryList.List[i].Quantity = req.body.Quantity
    //                         groceryList.List[i].Comment = req.body.Comment
    //                          GroceryList.findOneAndUpdate({
    //                             'User': req.user,
    //                             'GroceryListName': req.body.GroceryListName
    //                         },{
    //                             'List': groceryList.List
    //                         },{
    //                             safe:true, upsert:true, new: true
    //                         },
    //                         function(err, groceryList){
    //                             if(err)
    //                                 res.send(err)
    //                             if(groceryList)
    //                                 res.send(200)
    //                         })
    //                     }
    //                 }
    //             }else{
    //                 res.send(404);
    //             }
    //         })
    // })

  
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
