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
  		
    	var overlappingData = {
    	  labels: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,"21+"],
    	  series: [
    	    [
    	    	data.Distrubition[0],
    	    	data.Distrubition[1],
    	    	data.Distrubition[2],
    	    	data.Distrubition[3],
    	    	data.Distrubition[4],
    	    	data.Distrubition[5],
    	    	data.Distrubition[6],
    	    	data.Distrubition[7],
    	    	data.Distrubition[8],
    	    	data.Distrubition[9],
    	    	data.Distrubition[10],
    	    	data.Distrubition[11],
    	    	data.Distrubition[12],
    	    	data.Distrubition[13],
    	    	data.Distrubition[14],
    	    	data.Distrubition[15],
    	    	data.Distrubition[16],
    	    	data.Distrubition[17],
    	    	data.Distrubition[18],
    	    	data.Distrubition[19],
    	    	data.Distrubition[20],
    	    	data.Distrubition[21],
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
	
    	new Chartist.Bar('#exampleOverlappingBar', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar1', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar2', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar3', overlappingData, overlappingOptions, overlappingResponsiveOptions);
  		


  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})

  	$http.get("/getRecommendationBreakdown").success(function(data, status){
  		
    	var overlappingData = {
    	  labels: [1,2,3,4,5,6,7,8,9,10],
    	  series: [
    	    [
    	    	data.RecommendationBreakdownList[0],
    	    	data.RecommendationBreakdownList[1],
    	    	data.RecommendationBreakdownList[2],
    	    	data.RecommendationBreakdownList[3],
    	    	data.RecommendationBreakdownList[4],
    	    	data.RecommendationBreakdownList[5],
    	    	data.RecommendationBreakdownList[6],
    	    	data.RecommendationBreakdownList[7],
    	    	data.RecommendationBreakdownList[8],
    	    	data.RecommendationBreakdownList[9]
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
	
    	new Chartist.Bar('#exampleOverlappingBar1', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar1', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar2', overlappingData, overlappingOptions, overlappingResponsiveOptions);
    	// new Chartist.Bar('#exampleOverlappingBar3', overlappingData, overlappingOptions, overlappingResponsiveOptions);
  		


  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})
  
  	$http.get("/numberPerCategory").success(function(data, status){
  		
  		console.log(data.Categories.Produce)
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
	
    	new Chartist.Bar('#exampleOverlappingBar2', overlappingData, overlappingOptions, overlappingResponsiveOptions);

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


