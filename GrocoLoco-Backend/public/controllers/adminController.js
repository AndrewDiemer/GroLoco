//http://codepen.io/taye/pen/xEJeo
GrocoLoco.controller('adminController', function($scope, $http, $location) {
	var shapeCount = 1 ;
	var rectangles = []
	var svgCanvas = document.querySelector('svg'),
    svgNS = 'http://www.w3.org/2000/svg'

	function populateAisles(){
		$http.get('/aisles').success(function(data,status){
			console.log(data)
			console.log('adding shape')
			for (var i = 0; i < data.length; i++) {
				console.log(data[i])
				new Rectangle(data[i].x, data[i].y, data[i].w, data[i].h, svgCanvas);

				// var shape = '<div id="grid-snap-'+(i+1)+'" class="snap">'
				// 		+'  Shelf #'+ (i+1) 
				// 		+' </div>'

				// $('.container').append(shape)
				// initInteract((i+1), data[i].x, data[i].y)

				shapeCount = i

			};
			
		})
	}
	populateAisles()

	function Rectangle (x, y, w, h, svgCanvas) {
	  this.x = x;
	  this.y = y;
	  this.w = w;
	  this.h = h;
	  this.stroke = 5;
	  this.el = document.createElementNS(svgNS, 'rect');
	 
	  this.el.setAttribute('data-index', rectangles.length);
	  this.el.setAttribute('class', 'edit-rectangle');
	  rectangles.push(this);
	 
	  this.draw();
	  svgCanvas.appendChild(this.el);
	}
	 
	Rectangle.prototype.draw = function () {
	  this.el.setAttribute('x', this.x + this.stroke / 2);
	  this.el.setAttribute('y', this.y + this.stroke / 2);
	  this.el.setAttribute('width' , this.w - this.stroke);
	  this.el.setAttribute('height', this.h - this.stroke);
	  this.el.setAttribute('stroke-width', this.stroke);
	}

	$scope.addShape = function(){
		console.log('adding shape')

		var shape = '<div id="grid-snap-'+shapeCount+'" class="snap">'
					+'  Shelf #'+ shapeCount 
					+' </div>'

		$('.container').append(shape)
		initInteract(shapeCount, 0, 0)

		shapeCount++;
	}

	$scope.clearBlocks = function(){
		rectangles = []
		var length = $('#grid-snap-'+shapeCount).length

		for (var i = 0; i < length; i++) 
			$('#grid-snap-'+i).remove()
		
		$('.edit-rectangle').remove()
		$http.post('/deleteblocks')
		shapeCount = 1;
	}

	$scope.saveAllBlocks = function(){
		var aisles = $('.edit-rectangle')
		var blocks = []
		for (var i = 0; i < aisles.length; i++) {

			var block ={
				x: aisles[i].x.animVal.value,
				y: aisles[i].y.animVal.value,
				w: aisles[i].width.animVal.value,
				h: aisles[i].height.animVal.value
			}
			blocks.push(block)
		}
		var blockPackage = {
			'blocks': blocks
		}

		$http.post('/aisles', blockPackage)
		// for (var i = 0; i < aisles.length; i++) {
		// 	console.log(aisles[i].attr('x'))
		// 	console.log(aisles[i].attr('y'))
		// 	console.log(aisles[i].attr('w'))
		// 	console.log(aisles[i].attr('h'))
		// }

		
	}

	function initInteract(shapeCount, x0, y0){
		var shape = $('#grid-snap-'+shapeCount).css('margin', '0')
		var element = document.getElementById('grid-snap-'+shapeCount)
	    var x = x0
	    var y = y0

		interact(element)
		  .resizable({
		    // preserveAspectRatio: true,
		    edges: { left: true, right: true, bottom: true, top: true }
		  })
		  .draggable({
		  	onmove: window.dragMoveListener,
		    snap: {
		      targets: [
		        interact.createSnapGrid({ x: 20, y: 20 })
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