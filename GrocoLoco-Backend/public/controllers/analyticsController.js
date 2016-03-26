GrocoLoco.controller('analyticsController', function($scope, $http, $location) {

  	$http.get("/numberOfUsers").success(function(data,status){

		$('#currentNumberOfUsers').text(data.Number);

	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})

	$http.get("/averageGrocerySize").success(function(data,status){

		$('#averageListSize').text(data.Average.toPrecision(3));

	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})

  	$http.get("/getRecommendationTotal").success(function(data,status){

		$('#recommendedItemsPerList').text(data.TotalBreakdown.toPrecision(3));

	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})

  	$http.get("/averageGrocerySizeDistribution").success(function(data, status){
  		
  		var series = new Array(data.Distrubition.length);

  		for( var i = 0; i<data.Distrubition.length; i++ )
  		{
			series[i] = data.Distrubition[i];
  		}

    	var overlappingData = {
    	  labels: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,"21+"],
    	  series: [series]
    	  // TODO: For some reason series starts at the second bar in the graph rather than the first
    	};

    	var overlappingOptions = {
    	  seriesBarDistance: 20
    	};
	
    	var overlappingResponsiveOptions = [
    	  ['screen and (max-width: 640px)', {
    	    seriesBarDistance: 10,
    	    axisX: {
    	      labelInterpolationFnc: function(value) {
    	        return value[0];
    	      }
    	    }
    	  }]
    	];
	
    	new Chartist.Bar('#allListSizes', overlappingData, overlappingOptions, overlappingResponsiveOptions);
  		

  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})

  	$http.get("/getRecommendationBreakdown").success(function(data, status){
  		

    	var overlappingData = {
    	  labels: [.1,.2,.3,.4,.5,.6,.7,.8,.9,1],
    	  series: [
    	  [
    	  data.RecommendationBreakdownList["0.1"],
    	  data.RecommendationBreakdownList["0.2"],
    	  data.RecommendationBreakdownList["0.3"],
    	  data.RecommendationBreakdownList["0.4"],
    	  data.RecommendationBreakdownList["0.5"],
    	  data.RecommendationBreakdownList["0.6"],
    	  data.RecommendationBreakdownList["0.7"],
    	  data.RecommendationBreakdownList["0.8"],
    	  data.RecommendationBreakdownList["0.9"],
    	  data.RecommendationBreakdownList["1.0"]
    	  ]
    	  ]
    	};

    	var overlappingOptions = {
    	  seriesBarDistance: 20
    	};
	
    	var overlappingResponsiveOptions = [
    	  ['screen and (max-width: 640px)', {
    	    seriesBarDistance: 10,
    	    axisX: {
    	      labelInterpolationFnc: function(value) {
    	        return value[0];
    	      }
    	    }
    	  }]
    	];
	
    	new Chartist.Bar('#numItemsFromRecommendations', overlappingData, overlappingOptions, overlappingResponsiveOptions);		


  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})
  
  	$http.get("/numberPerCategory").success(function(data, status){
  		
    	var overlappingData = {
    	  labels: ["Produce", "Dairy", "Deli", "Frozen", "Grains", "Cans", "PersonalCare", "Bakery", "Other"],
    	  series: [
    	    [
    	    	data.Categories.Produce,
    	    	data.Categories.Dairy,
    	    	data.Categories.Deli,
    	    	data.Categories.Frozen,
    	    	data.Categories.Grains,
    	    	data.Categories.Cans,
    	    	data.Categories.PersonalCare,
    	    	data.Categories.Bakery,
    	    	data.Categories.Other
    	    ]
    	  ]
    	};

    	var overlappingOptions = {
    	  seriesBarDistance: 20
    	};
	
    	var overlappingResponsiveOptions = [
    	  ['screen and (max-width: 640px)', {
    	    seriesBarDistance: 10,
    	    axisX: {
    	      labelInterpolationFnc: function(value) {
    	        return value[0];
    	      }
    	    }
    	  }]
    	];
	
    	new Chartist.Bar('#purchasesPerCategory', overlappingData, overlappingOptions, overlappingResponsiveOptions);

  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})


  // Example Chartist Simple Pie
  // ---------------------------

    var simplePiedata = {
      series: [5, 3, 4]
    };

    var simplePieSum = function(a, b) {
      return a + b;
    };

    new Chartist.Pie('#exampleSimplePie', simplePiedata, {
      labelInterpolationFnc: function(value) {
        return Math.round(value / simplePiedata.series.reduce(simplePieSum) * 100) + '%';
      }
    });

})


