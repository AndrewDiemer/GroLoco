module.exports = CreateData;

var GroceryItem = db.model('GroceryItem', groceryItemSchema);
var BlockCoordinates = db.model('BlockCoordinates', blockCoordinatesSchema);

//-----------------------------------GOOOOOOOOOOO-----------------------------------------------------
function CreateData() {
  DeleteAllItems();
}

// ============================= DELETE GROCERY ITEMS  ====================================

function DeleteAllItems() {
  console.log('Deleting previous items');
  GroceryItem.remove({
      
  }, function(err, GroceryItems){
      if(err) res.send(err);
  })
}

// ============================= CREATE MOCK GROCERY ITEMS ====================================

function CreateGroceryItem(UPC, Description, POSDescription, SubCategory, Aisle, AisleShelf, Position) {

  console.log('Creating Mock Data');
  var UPCcode = Math.floor((Math.random() * 9999999999) + 1);
  var newItem = new GroceryItem({
    UPC            : UPC, //UPCcode, //"5820008030",
    Description    : Description,
    POSDescription : POSDescription,
    SubCategory    : SubCategory,
    Aisle          : Aisle, // created by taking Aisle info from Sobeys and removing shelf id from the end 
    AisleShelf     : AisleShelf,  // created from full Aisle info from Sobeys
    Position       : Position
  });
  newItem.save(function (err) { if (err) console.log(err); })
}


// ============================= CREATE BLOCK COORDINATE DATA  ====================================

function CreateBlockCoordData(UPC, x1, x2, y1, y2) {
  console.log('Creating Block Coordinate Data');
  var UPCcode = Math.floor((Math.random() * 9999999999) + 1);
  var newBlockCoords = new BlockCoordinates({
    'UPC' : UPC,
    'x1'  : x1,
    'y1'  : y1,
    'x2'  : x2,
    'y2'  : y2
  });
  newBlockCoords.save(function (err) { if (err) console.log(err); })
}


// ============================= CREATE ITEM WIDTH DATA  ====================================

function CreateItemWidthData(UPC, Width) {
  console.log('Creating Item Width Data');
  var UPCcode = Math.floor((Math.random() * 9999999999) + 1);
  var newItemWidth = new ItemWidth({
      'UPC'            : UPC, //UPCcode,
      'Width'          : Width
  });
  newItemWidth.save(function (err) { if (err) console.log(err); });
}

// ============================= FIND COORDINATES FOR ITEMS  ====================================

function FindCoordinatesForItems() {
  GroceryItem.find({ }, function(err, items){
    if(err) {
      console.log('error trying to find grocery data');
    }
    if(items) {
      for(var i = 0; i < items.length; i++) {
        // found item, now need to get and set its coordinates
        console.log('about to find coordinates');

        var UPC            = items[i].UPC;
        var Description    = items[i].Description;
        var POSDescription = items[i].POSDescription;
        var SubCategory    = items[i].SubCategory;
        var Aisle          = items[i].Aisle;  // created by taking Aisle info from Sobeys and removing shelf id from the end 
        var AisleShelf     = items[i].AisleShelf;  // created from full Aisle info from Sobeys
        var Position       = items[i].Position;                

        console.log('about to look for blockcoordinates of this upc: '+UPC);
        
        BlockCoordinates.findOne({ 'UPC' :  UPC }, function(err, blockCoordinates) {
            if (err){
                console.log("error trying to find blockcoords: " + err);                    
            } else if (blockCoordinates) {                                               

                GroceryItem.find({'AisleShelf' : AisleShelf}).sort('Position').exec(function(err, groceryItems) {
                  if(err) {
                      console.log(err);
                      //res.send(err)
                  } else if(groceryItems) {
                      console.log("found: " + groceryItems.length + " groceryItems on the same shelf!");                      

                      var dist = 0;
                      var itemDist;
                      var dbCallFinished = false; 

                      function asyncLoop( i, callback ) {
                          if( i < groceryItems.length ) {
                              if(groceryItems[i].UPC == UPC) {                                                        
                                  console.log("yay found the item");
                                  itemDist = dist;
                                  asyncLoop( i+1, callback );                                                    
                              } else {                                                                                                
                                  ItemWidth.findOne({
                                      'UPC': UPC
                                  }, function(err, item){
                                      if(err)
                                          console.log('error occurred while trying to find width: ' + err);
                                          //res.send(err);
                                      if(item){
                                          //console.log('found and adding width: ');
                                          //console.log(item.Width);
                                          dist += item.Width; // in inches --> width of whole aisle / number of positions in aisle 
                                          asyncLoop( i+1, callback );                                                    
                                      } else {
                                          console.log('couldnt find this upc codes width');
                                          //res.send(404);
                                      }
                                  })     
                              }                                            
                          } else {
                              callback();
                          }
                      }   

                      asyncLoop( 0, function() {
                          // put the code that should happen after the loop here
                          console.log('running code after async');                                                                                                                                                                    

                          console.log('item distance is: ' + itemDist);
                          console.log('width of aisle is: ' + dist);

                          var distPerc = itemDist/dist;
                          console.log('distance percentage to item is: ' + distPerc);
                          console.log("X2: " + blockCoordinates.x2 + ", X1: " + blockCoordinates.x1);
                          var blockDist = blockCoordinates.x2 - blockCoordinates.x1;
                          console.log('block length: '+blockDist);

                          var itemx =  distPerc * blockDist;                                                                        

                          var itemCoordinates = {x : itemx, y : blockCoordinates.y1};                                    
                          console.log("Item coordinates: ");
                          console.log(itemCoordinates);                                                                                                            

                          GroceryItem.findOneAndUpdate({ 'UPC': UPC }, {
                              UPC            : UPC,
                              Description    : Description,
                              POSDescription : POSDescription,
                              SubCategory    : SubCategory,
                              Aisle          : Aisle,  // created by taking Aisle info from Sobeys and removing shelf id from the end 
                              AisleShelf     : AisleShelf,  // created from full Aisle info from Sobeys
                              Position       : Position,
                              Coordinates    : itemCoordinates                               
                          }, function(err, item){
                              if(err) {
                                  console.log("error trying to find groceryItem: " + err);    
                                  //res.send(err)                
                              } else if(item) {
                                  console.log('successfully found and set coordinates');                                                  
                                  //res.send(item);                                                
                              } else {
                                  console.log('could not update coordinates of grocery item');  
                                  //res.send('could not update coordinates of grocery item');         
                              }
                          });
                      });
                  } else {
                      console.log(404);
                      //res.send(404);
                  }
                });         

            } else {
              console.log("could not find block coordinates for this UPC code");
              //res.send("could not find block coordinates for this UPC code");
            }
        }); 
      }       
    } else {
      console.log("couldn't find any items");
    }
  });
}
