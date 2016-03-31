var raccoon = require('raccoon')
var _ = require('lodash')
var clone = require('clone')


module.exports = function (app){
	app.get('/getitems', isAuthenticated, function(req,res){
        GroceryItem.find({}, function(err, items){
            if(err)
                res.send(err)
            if(items){
                res.send(items)
            }else{
                res.send(404)
            }
        })
    })

    app.get('/items/:category', function(req, res){
        GroceryItem.find({
            "Category": req.params.category
        }, function(err, groceryItems){
            if(err)
                res.send(err)
            if(groceryItems){
                res.send(groceryItems)
            }
            else
                res.send(404)
        })
    })

    app.post('/category', isAuthenticated, function(req, res){
        GroceryItem.find({
            "Category": req.body.categoryNumber
        }, function(err, groceryItems){
            if(err)
                res.send(err)
            if(groceryItems){
                res.send(groceryItems.sort(function(a, b) { return a.Description.toLowerCase().localeCompare(b.Description.toLowerCase())}))
            }
            else
                res.send(404)
        })
    })

    app.post('/groceryitems', isAuthenticated, function(req, res){
        GroceryList.findOneAndUpdate({
            'User': req.user,
            'GroceryListName': req.body.GroceryListName
        },{
            'List': []
        },{
            safe:true, upsert:true, new: true
        },
        function(err, groceryList){
            if(err)
                res.send(err)
            if(groceryList)
                res.send(groceryList)
        })
    })

    app.delete('/groceryitem', isAuthenticated, function(req, res){
        GroceryList.findOne({
            'User': req.user,
            'GroceryListName': req.body.GroceryListName
        }, function(err, groceryList){
            if(err)
                res.send(err)
            if(groceryList){
                for(var i = 0; i < groceryList.List.length; i++){
                    if(groceryList.List[i]._id == req.body._id){

                        groceryList.List.splice(i, 1);

                         GroceryList.findOneAndUpdate({
                            'User': req.user,
                            'GroceryListName': req.body.GroceryListName
                        },{
                            'List': groceryList.List
                        },{
                            safe:true, upsert:true, new: true
                        },
                        function(err, groceryList){
                            if(err)
                                res.send(err)
                            if(groceryList){
                                res.send(groceryList)
                            }
                        })
                    }
                }
            }else{
                res.send(404);
            }
        })
    })

    app.post('/editgroceryitemcomment', isAuthenticated, function(req, res){
        GroceryList.findOne({
                'User': req.user,
                'GroceryListName': req.body.GroceryListName
            }, function(err, groceryList){
                if(err)
                    res.send(err)
                if(groceryList){
                    for(var i = 0; i < groceryList.List.length; i++){
                        if(groceryList.List[i]._id == req.body._id){
                            // console.log(req.body.Comment)
                            groceryList.List[i]["Comment"] = req.body.Comment
                            // console.log(groceryList.List[i])
                             GroceryList.findOneAndUpdate({
                                'User': req.user,
                                'GroceryListName': req.body.GroceryListName
                            },{
                                'List': groceryList.List
                            },{
                                safe:true, upsert:true, new: true
                            },
                            function(err, groceryList){
                                if(err)
                                    res.send(err)
                                if(groceryList)
                                    res.send(200)
                            })
                        }
                    }
                }else{
                    res.send(404);
                }
            })
    })

  app.delete('/deletegrocerylist', isAuthenticated, function(req,res){
        GroceryList.findOneAndRemove({
                'User': req.user,
                'GroceryListName': req.body.GroceryListName
            }, function (err, groceryList){
            if(err) 
                res.send(err)
            if(groceryList){
                for(var i = 0; i < req.user.GroceryList.length; i++){
                    var userClone = clone(req.user)

                    if(req.user.GroceryList[i].toString() == groceryList._id.toString()){

                        var index = userClone.GroceryList.indexOf(groceryList._id)
                    
                        // console.log("Index: " + index)
                        userClone.GroceryList.splice(index, 1);


                        User.findOneAndUpdate({
                            'Email': userClone.Email
                        },{
                            'GroceryList': userClone.GroceryList
                        },function(err,user){
                            if(err)
                                res.send(err)
                            if(user)
                                res.send(user)
                            else
                                res.send(404)
                        })
                    }else{
                        res.send(500)
                        console.log('else here')
                    }
                }
            }
            else{
                console.log("here")
                res.send(404)
            }
        })
    })

    app.get('/grocerylists', isAuthenticated, function(req,res){
        GroceryList.find({
            'User':req.user
        }, function(err, grocerylists){
            if(err)
                res.send(err)
            if(grocerylists)
                res.send(grocerylists)
            else
                res.send(404)
        })
    })

  

    app.post('/newgrocerylist', isAuthenticated, function(req, res) {

        var newGroceryList = new GroceryList({
            'User'              : req.user,
            'GroceryListName'   : req.body.GroceryListName
        });

        newGroceryList.save(function(err, newGroceryList){
            if(err)
                res.send(err)
            if(newGroceryList){
                User.findOneAndUpdate({
                    'Email': req.user.Email
                },{
                    $push:{'GroceryList':newGroceryList}
                },{
                    safe:true, upsert:true, new: true
                },
                function(err,user){
                    if(err)
                        res.send(err)
                    if(user)
                        res.send(user)
                })
            }
        })
    })

    app.post('/finditems', isAuthenticated, function(req, res){
        var itemList = []
        var subSearch = req.body.subsearch.toLowerCase()
        if (subSearch==' ') {
            res.send(itemList)
        };

        var time_1 = Date.now()
        var time_2 = 0
        var total_time = 0

        var redisQuery = 'autocomplete/' + encodeURI(subSearch)
        // console.log(redisQuery)

        client.get(redisQuery, function(err, data){
            if(err)
                res.send(err)
            if(data){
                time_2 = Date.now()
                total_time = time_2-time_1
                // console.log('Time to retrieve using Redis: ' + total_time+'ms')
                res.send(JSON.parse(data))
            }else{
                GroceryItem.find({}, function(err, groceryitems){
                    if(err)
                        res.send(err)
                    if(groceryitems){

                        var subSearchList = subSearch.split(' ')

                        for(var i = 0; i < groceryitems.length; i++){
                            var added = false

                                //check the description
                                if(groceryitems[i].Description && !added ){
                                    var descriptionListOfWords = groceryitems[i].Description.split(' ')
                                    // console.log(descriptionListOfWords)
                                    for (var j = 0; j < descriptionListOfWords.length; j++) {
                                        var addedInner = false
                                        //check if it's greater than the substring
                                        if(subSearch.length > descriptionListOfWords[j].length && descriptionListOfWords[j].toLowerCase() == subSearch.substring(0, descriptionListOfWords[j].length).toLowerCase()){
                                            console.log('here')
                                            j++
                                            while(1){
                                                var subSearchLong = subSearch.substring(descriptionListOfWords[j-1].length+1, subSearch.length)
                                                console.log(subSearchLong)
                                                if(descriptionListOfWords[j].substring(0, subSearchLong.length).toLowerCase() == subSearchLong.toLowerCase()){
                                                    itemList.push(groceryitems[i])
                                                    addedInner = true
                                                    added = true
                                                    break;
                                                }
                                                j++
                                                if(j>=descriptionListOfWords.length)
                                                    break;
                                            }
                                            break;
                                            
                                        }else if (!addedInner && descriptionListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
                                            // console.log('here2')
                                            // console.log(subSearch.length)
                                            // console.log(descriptionListOfWords[j].length)
                                            
                                            itemList.push(groceryitems[i])
                                            added = true
                                            break;
                                        }                            
                                        
                                    }
                                }

                                // // //check the POS Description
                                // if(groceryitems[i].POSDescription && !added){
                                //     var POSDescriptionListOfWords = groceryitems[i].POSDescription.split(' ')
                                //     console.log(POSDescriptionListOfWords)

                                //     for (var j = 0; j < POSDescriptionListOfWords.length; j++) {
                                //         var addedInner = false
                                //         //check if it's greater than the substring
                                //         if(subSearch.length > POSDescriptionListOfWords[j].length && POSDescriptionListOfWords[j].toLowerCase() == subSearch.substring(0, POSDescriptionListOfWords[j].length).toLowerCase()){
                                //             console.log('here')
                                //             j++
                                //             while(1){
                                //                 var subSearchLong = subSearch.substring(POSDescriptionListOfWords[j-1].length+1, subSearch.length)
                                //                 console.log(subSearchLong)
                                //                 if(POSDescriptionListOfWords[j].substring(0, subSearchLong.length).toLowerCase() == subSearchLong.toLowerCase()){
                                //                     itemList.push(groceryitems[i])
                                //                     addedInner = true
                                //                     added = true
                                //                     break;
                                //                 }
                                //                 j++
                                //                 if(j>=POSDescriptionListOfWords.length)
                                //                     break;
                                //             }
                                //             break;
                                            
                                //         }else if (!addedInner && POSDescriptionListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
                                //             console.log('here2')
                                //             console.log(subSearch.length)
                                //             console.log(POSDescriptionListOfWords[j].length)
                                            
                                //             itemList.push(groceryitems[i])
                                //             added = true
                                //             break;
                                //         }                            
                                        
                                //     }
                                // }

                                // // //check sub category
                                // if(groceryitems[i].SubCategory && !added){
                                //     var subCategoryListOfWords = groceryitems[i].SubCategory.split(' ')
                                //     console.log(subCategoryListOfWords)

                                //     for (var j = 0; j < subCategoryListOfWords.length; j++) {
                                //         var addedInner = false
                                //         //check if it's greater than the substring
                                //         if(subSearch.length > subCategoryListOfWords[j].length && subCategoryListOfWords[j].toLowerCase() == subSearch.substring(0, subCategoryListOfWords[j].length).toLowerCase()){
                                //             console.log('here')
                                //             j++
                                //             while(1){
                                //                 var subSearchLong = subSearch.substring(subCategoryListOfWords[j-1].length+1, subSearch.length)
                                //                 console.log(subSearchLong)
                                //                 if(subCategoryListOfWords[j].substring(0, subSearchLong.length).toLowerCase() == subSearchLong.toLowerCase()){
                                //                     itemList.push(groceryitems[i])
                                //                     addedInner = true
                                //                     added = true
                                //                     break;
                                //                 }
                                //                 j++
                                //                 if(j>=subCategoryListOfWords.length)
                                //                     break;
                                //             }
                                //             break;
                                            
                                //         }else if (!addedInner && subCategoryListOfWords[j].substring(0, subSearch.length).toLowerCase() == subSearch.toLowerCase()){
                                //             console.log('here2')
                                //             console.log(subSearch.length)
                                //             console.log(subCategoryListOfWords[j].length)
                                            
                                //             itemList.push(groceryitems[i])
                                //             added = true
                                //             break;
                                //         }                            
                                        
                                //     }
                                // }
                            // }
                        }

                        time_2 = Date.now()
                        total_time = time_2-time_1
                        console.log(redisQuery)
                        if(added){
                            console.log(redisQuery)
                            client.set(redisQuery, JSON.stringify(itemList))
                        }
                        // console.log('Time to retrieve using MongoDB: ' + total_time+'ms')
                        res.send(itemList)
                    }
                    else
                        res.send(404)
               })
            }
        })
    });  

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
