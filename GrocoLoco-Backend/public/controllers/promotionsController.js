

GrocoLoco.controller('promotionsController', function($scope, $http, $location) {


	$scope.addPromoTemp = function(promo){
		$scope.promoDescription = promo.Description
		$scope.promoPrice = promo.Price
		$scope._id = promo._id
	}



	$http.get('/groceries').success(function(data, status){
		console.log(data)
		$scope.persons = data
	})
	
	$scope.dateHack = function(){
		$('.ui-timepicker-wrapper').css('z-index', '100000')
	}


	$scope.removePromo = function(promo){
		console.log(promo)
		$http.post('/removePromo', promo).success(function(data, status){
			console.log(data)
			console.log(status)
			location.reload()
		}).error(function(data, status){
			console.log(data)
			console.log(status)
		})
	}

function ISODateString(d){
 function pad(n){return n<10 ? '0'+n : n}
 return d.getUTCFullYear()+'-'
      + pad(d.getUTCMonth()+1)+'-'
      + pad(d.getUTCDate())+'T'
      + pad(d.getUTCHours())+':'
      + pad(d.getUTCMinutes())+':'
      + pad(d.getUTCSeconds())+'Z'
  }

	$scope.savePromo = function(){

		var type = ''

		if($("input[name=discount-type]:checked").get(0).id == 'type-value'){
			type = "$"
		}else{
			type = "%"
		}

		
		//Get the promotions
		var promotion = {}
		var promoDiscount = $('#promotion-discount').val()


		//converts the date to the proper javascript 339 time
		var startTime 	= $('#start-time').val()
		var startDate 	= $('#start-date').val() 

		var d1 = Date.parse(startDate + ', ' + startTime)
		d1 = ISODateString(d1)
		console.log(d1)

		var endTime 	= $('#end-time').val()
		var endDate 	= $('#end-date').val()

		var d2 = Date.parse(endDate + ', ' + endTime)
		d2 = ISODateString(d2)
		console.log(d2)


		//get type of discount
		if(type == '%'){
			promotion = {
				IsPromo 		: true,
	            PromoTitle      : 'Get ' + promoDiscount + type + ' off!',
	            PromoDiscount   : promoDiscount/100,
	            Type       		: type,
	            PromoStartDate  : d1,
	            PromoEndDate    : d2,
	            _id				: $scope._id
	    	}
		}else{
			promotion = {
				IsPromo 		: true,
	            PromoTitle      : 'Get ' + type + promoDiscount + ' off!',
	            PromoDiscount   : promoDiscount,
	            Type       		: type,
	            PromoStartDate  : d1,
	            PromoEndDate    : d2,
	            _id				: $scope._id
	    	}
		}

	    console.log(promotion)

		$http.post('/addPromo', promotion)
		.success(function(data, status){
			console.log(status)
			console.log(data)
			location.reload()
		}).error(function(data, status){
			console.log(status)
			console.log(data)
		})
	}
	
})