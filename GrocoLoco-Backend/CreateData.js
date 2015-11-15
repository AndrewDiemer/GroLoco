
module.exports = CreateData;

function CreateData() {

  var GroceryItem = db.model('GroceryItem', groceryItemSchema);

  // console.log('Deleting previous items');

  // GroceryItem.remove({
  //     Description    : "Lucerne Ice Cream Vanilla"
  // }, function(err, GroceryItems){
  //     if(err) res.send(err);
  // })
    



  // console.log('Creating Mock Data');

  // var UPCcode = Math.floor((Math.random() * 9999999999) + 1);

  // var newItem = new GroceryItem({
  //   UPC            : UPCcode, //"5820008030",
  //   Description    : "Lucerne Ice Cream Vanilla",
  //   POSDescription : "Ice Cream Vanilla",
  //   SubCategory    : "Frozen Ice Cream",
  //   Aisle          : "10L", // created by taking Aisle info from Sobeys and removing shelf id from the end 
  //   AisleShelf     : "10L01",  // created from full Aisle info from Sobeys
  //   Position       : "3"
  // });
  
  // newItem.save(function (err) { if (err) console.log(err); })

}
