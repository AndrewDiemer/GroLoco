

//ROUTES ===========================================================

module.exports = function (app){

    app.post('/newItem', function(req, res) {
        console.log('Posting a new item')

        var newItem = new GroceryItem({
            ItemName       : req.body.itemName,
            SKU            : req.body.sku,
            LocationID     : req.body.locationID,
        });

        newItem.save(function(err, user){
            if(err)
                res.send(err)
            if(user)
                res.send(user)
        })

    });
}
