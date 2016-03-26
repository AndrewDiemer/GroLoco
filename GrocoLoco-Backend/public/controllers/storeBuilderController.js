
GrocoLoco.controller('storeBuilderController', function($scope, $http, $location) {
	$scope.width = 300
	$scope.height = 300
	console.log($scope.width)
	console.log($scope.height)

	$scope.change = function() {
        $('rect').attr('width',$scope.width)
        $('rect').attr('height',$scope.height)
    };

	var shapeCount = 1 ;
	
	$scope.addShape = function(){
		console.log('adding shape')

		var shape = '<div id="grid-snap-'+shapeCount+'" class="snap">'
					+'  Shelf #'+ shapeCount 
					+' </div>'

		$('.container').append(shape)
		initInteract(shapeCount)

		shapeCount++;
	}

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