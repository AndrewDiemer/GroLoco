
var ItemCoordinates = require('./itemCoordinates');
var BlockCoordinates = require('./blockCoordinates');

groceryItemSchema = new db.Schema({
	UPC            : String,
	Description    : String,
	POSDescription : String,
  Category       : String,
	SubCategory    : String,
	Aisle  	       : String,  // created by taking Aisle info from Sobeys and removing shelf id from the end 
	AisleShelf     : String,  // created from full Aisle info from Sobeys
	Position       : String,  // from somewhere on Sobeys end
	Coordinates    : { 
        x        : Number, 
        y        : Number 
  }
})

groceryItemSchema.methods.setcoordinates = function setcoordinates(cb) {
	//console.log('finding coordinates...');

	var blockCoordinates = FindBlockCoordinates(this.Aisle);
	//console.log('found block coords: ' + blockCoordinates.y2);
	var upc = this.UPC;	
	GroceryItem.find({'AisleShelf' : this.AisleShelf}).sort('Position').exec(function(err, groceryItems) {
            if(err) {
                console.log(err);
            } else if(groceryItems) {
            	console.log("found: " + groceryItems.length + " groceryItems!");                   	

            	var dist = 0;
            	var itemDist;
            	for(var i=0;i<groceryItems.length;i++) {    
            	console.log(groceryItems[i]);          	
            		if(groceryItems[i].UPC == upc) {            			
            			console.log('found my item in the aisle!');
            			itemDist = dist;
            		} else {
	            		
	            		//placeholder
	            		//var width = database.find(UPC)
	            		var width = 0.8; // in inches --> width of whole aisle / number of positions in aisle 
	           		
	           			dist += width;
            		}
            	}
            	
            	console.log('item distance is: ' + itemDist);
            	console.log('width of aisle is: ' + dist);


            	var distPerc = itemDist/dist;
            	console.log('distance percentage to item is: ' + distPerc);

            	var blockDist = blockCoordinates.x2 - blockCoordinates.x1;
            	console.log('block length: '+blockDist);

            	var itemx =  distPerc * blockDist;
            	
            	var itemCoordinates = new ItemCoordinates(itemx,blockCoordinates.y1);
            	console.log(itemCoordinates);

            } else
                console.log(404);
        });



	//placeholder
	var itemCoordinates = new ItemCoordinates(5,3);

	//console.log('Setting Coordinates. x: ' + itemCoordinates.x + ' y: '+itemCoordinates.y);
	this.Coordinates.x = itemCoordinates.x;
	this.Coordinates.y = itemCoordinates.y;
	return this.save(cb);
 }

  function FindBlockCoordinates(aisle) {
 	//console.log('finding block coordinates');


 	// //pull from database item
 	// BlockCoords.findOne({'aisle': aisle }, function(err, blockCoords){
  //       if(err)
  //           res.send(err);
  //       if(blockCoords) {
            
  //           // found block, now need to use its coordinates and set its coordinates
  //           return new BlockCoordinates(blockCoords.x1, blockCoords.y1, blockCoords.x2, blockCoords.y2);   

  //       } else {
  //           res.send(404)
  //       }
  //   })
	
	//placeholder
 	return new BlockCoordinates(5, 3, 6, 4);
 }

