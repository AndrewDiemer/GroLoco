
GrocoLoco.controller('storeBuilderController', function($scope, $http, $location) {
	$scope.currentStore = ''
	$scope.storeId = ''

	function disableAll(){
		$('#green-button').addClass('disabled')
		$('#red-button').addClass('disabled')
		$('#save-all').addClass('disabled')
		$('#width').prop('disabled', true)
		$('#height').prop('disabled', true)
	}

	function unDisableAll(){
		$('#green-button').removeClass('disabled')
		$('#width').prop('disabled', false)
		$('#height').prop('disabled', false)
		console.log('playin god out here')
	}

	function getLocation() {
		console.log('geo')
	    if (navigator.geolocation) {
	        navigator.geolocation.getCurrentPosition(showPosition);
	    } else {
	        console.log("Geolocation is not supported by this browser.")
	    }
	}

	function showPosition(position) {

		var store = {
			Address: $('#address').val(),
			StoreName: $('#store-name').val(),
			Longitude: position.coords.longitude,
			Latitude: position.coords.latitude,
			Width: $('#width-dim').val(),
			Length: $('#height-dim').val()
		}

		console.log(store)

		$http.post('/createStore', store).success(function(data, status){

			unDisableAll()

			//create the dimension of the building
			$scope.width = $('#width-dim').val()
			$scope.height = $('#height-dim').val()

			//update the SVG
			$('rect').attr('width', $scope.width)
        	$('rect').attr('height', $scope.height)
        	$scope.currentStore = $('#store-name').val()

        	$('#store-name').val('')
        	$('#address').val('')
        	$('#width-dim').val('')
        	$('#height-dim').val('')
        	$scope.storeId = data._id

		}).error(function(data, status){

		})
	}

	$scope.closeCreateStore = function(){
		working = !working
	}

	$scope.createStorePost = function(){
		//this reoute first gets youre lng and lat, 
		//and takes care of the saving of the store
		getLocation()
	}

	$scope.detectBounds = function(Cx, Cy, Cw, Ch, Bx, By, Bw, Bh){
		//Check for vertical insideness (keep it pg morgan)
		if((By > Cy)&&((By+Bh) < (Cy + Ch))){
			console.log('Good with y')
			//Check for horizontal insideness 
			if((Bx > Cx)&&((Bx+Bw)<(Cx + Cw))) {
				console.log('Good with x')
				return true;

			}
		}

		return false;
	}

	// $scope.convertAbsoluteToRelativePositionCanvas = function(Canvas){

	// 	var RatioCanvas = {
	// 		x: 0,
	// 		w: 0,
	// 		h: 
	// 		y:
	// 	}

	// 	return RatioCanvas;
	// }

	$scope.convertAbsoluteToRelativePositionBlock = function(Canvas, Block){
		var RatioBlock = {
			w: Block.w / Canvas.w,
			h: Block.h / Canvas.h,
			x: (Block.x - Canvas.x) / Canvas.w ,
			y: (Block.y - Canvas.y) / Canvas.h,
		}
		return RatioBlock
	}

	$scope.saveAllBlocks = function(){
		var aisles = $('.edit-rectangle')
		var blocks = []
		var checkForBlocks = true;

		//get canvas and legths of pixels
		var canvas = $('#store-rect')
		var lengthX = canvas.css('x').length 
		var lengthY = canvas.css('y').length 

		var C = {
			x: Number(canvas.css('x').substring(0, lengthX - 2)),
			y: Number(canvas.css('y').substring(0, lengthY - 2)), 
			w: Number(canvas.attr('width')),
			h: Number(canvas.attr('height'))
		}

		for (var i = 0; i < aisles.length; i++) {

			var B ={
				x: aisles[i].x.animVal.value,
				y: aisles[i].y.animVal.value,
				w: aisles[i].width.animVal.value,
				h: aisles[i].height.animVal.value
			}
			console.log(C)
			console.log(B)
			if($scope.detectBounds(C.x,C.y,C.w,C.h, B.x, B.y, B.w, B.h)){
				// console.log()
				blocks.push($scope.convertAbsoluteToRelativePositionBlock(C, B))
			}else{
				alert('There are blocks that are outside the canvas area! Please fix before continuing.')
				checkForBlocks = false;
				break;
			}
		}

		if(checkForBlocks){
			var blockPackage = {
				'blocks': blocks,
				'storeId': $scope.storeId
			}
			console.log(blockPackage)
		}

		$http.post('/blocks', blockPackage).success(function(data,status){
			console.log(data)
			console.log(status)
		})
	}

	$scope.createStore = function(){
		if(!working){
			$('#myCreateStoreModal').modal()
			working = !working
		}else{
			if (confirm('Are you sure you want destroy your masterpeice?')) {
			    // Save it!
			    alert('suit yourself!')
			    location.reload()

			} else {
			    // Do nothing!
			}
		}
		
	}

	$scope.uploadStoreContents = function(){
		console.log($('#select-stores').val())
		// $http
		console.log('Uploading...')
	}

	$scope.uploadStore = function(){
		if(!working){
			$('#myUplodStoreModal').modal()
			$http.get('/stores').success(function(data, status){
				for (var i = data.length - 1; i >= 0; i--) {
					var el = '<option value="'+data[i]._id+'">'+ data[i].StoreName +'</option>'
					$('#select-stores').append(el)
				}
			})
			working = !working
		}else{
			if (confirm('Are you sure you want destroy your masterpeice?')) {
			    // Save it!
			    alert('suit yourself!')
			    location.reload()

			} else {
			    // Do nothing!
			}
		}
		
	}

	disableAll()
	// unDisableAll()


	


	$scope.add = function(){

		var rel = {
			Category: $('#categories').val(),
			Description: $('#items').val(),
			Side: $('#side').val(),
			Distance: $scope.bedSlider.value/100
		}

		console.log(rel)

		switchContextToDefault()

	}

	$('#categories').change(function(){
		$('.dropdown-items').remove()
		$http.get('/items/' + $('#categories').val()).success(function(data, status){
			for (var i = 0; i < data.length; i++) {
				var el = '<option value="'+data[i].Description+'" class="dropdown-items">' + data[i].Description + '</option>'
				$('#items').append(el)
			}
		})
	})

	$scope.bedSlider = {
		value: 100,
		vertical: true,
		options:{
			showSelectionBar: true
		}
	}

	$scope.width = 0
	$scope.height = 0
	// $('#myModal').modal({ show: false})

	// console.log($scope.width)
	// console.log($scope.height)

	$scope.change = function() {
        $('rect').attr('width',$scope.width)
        $('rect').attr('height',$scope.height)
    };

    $scope.close = function(){
    	$("#"+blox).attr('class','edit-rectangle')
    	lock = false
    	changing = !changing
    	$('#green-button').text('Add Block')
        $('#red-button').text('Delete All')
    }

	var shapeCount = 1 ;
	
	// $scope.addShape = function(){
	// 	console.log('adding shape')
	// 	console.log(changing)

	// 	if(!changing){

	// 		alert('Bitch please')
	// 	}else{
	// 		var shape = '<div id="grid-snap-'+shapeCount+'" class="snap">'
	// 				+'  Shelf #'+ shapeCount 
	// 				+' </div>'

	// 		$('.container').append(shape)
	// 		initInteract(shapeCount)

	// 		shapeCount++;
	// 	}

		
	// }

	function initInteract(shapeCount){
		var shape = $('#grid-snap-'+shapeCount).css('margin', '0')
		var element = document.getElementById('grid-snap-'+shapeCount)
	    var x = 0 
	    var y = 0

		interact(element)
		  .resizable({
		    // preserveAspectRatio: true,
		    edges: { left: true, right: true, bottom: true, top: true }
		  })
		  .draggable({
		  	onmove: window.dragMoveListener,
		    snap: {
		      targets: [
		        interact.createSnapGrid({ x: 30, y: 30 })
		      ],
		      range: Infinity,
		      relativePoints: [ { x: 0, y: 0 } ]
		    },
		    // inertia: true,
		    restrict: {
		      restriction: element.parentNode,
		      elementRect: { top: 0, left: 0, bottom: 1, right: 1 },
		      endOnly: true
		    }
		  })
		  .on('dragmove', function (event) {
		    x += event.dx;
		    y += event.dy;

		    event.target.style.webkitTransform =
		    event.target.style.transform =
		        'translate(' + x + 'px, ' + y + 'px)';
		  }).on('resizemove', function (event) {
		    var target = event.target,
		        x = (parseFloat(target.getAttribute('data-x'))),
		        y = (parseFloat(target.getAttribute('data-y')));

		    // update the element's style
		    target.style.width  = event.rect.width + 'px';
		    target.style.height = event.rect.height + 'px';

		    // translate when resizing from top or left edges
		    x += event.deltaRect.left;
		    y += event.deltaRect.top;
		    console.log(event)

		    target.style.webkitTransform = target.style.transform =
		        'translate(' + x + 'px,' + y + 'px)';

		    target.setAttribute('data-x', x);
		    target.setAttribute('data-y', y);
		    // target.textContent = Math.round(event.rect.width) + '×' + Math.round(event.rect.height);
		  });
	}



})