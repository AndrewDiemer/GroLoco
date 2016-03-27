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

  		var series = [
    	    			data.Categories.Produce,
    	    			data.Categories.Dairy,
    	    			data.Categories.Deli,
    	    			data.Categories.Frozen,
    	    			data.Categories.Grains,
    	    			data.Categories.Cans,
    	    			data.Categories.PersonalCare,
    	    			data.Categories.Bakery,
    	    			data.Categories.Other
    	    		];
  		
    	var overlappingData = {
    	  labels: ["Produce", "Dairy", "Deli", "Frozen", "Grains", "Cans", "PersonalCare", "Bakery", "Other"],
    	  series: [series]
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

//TODO: Cooler pie chart but getting weird error...Ask Morgan to investigate
    // var pie_chart = c3.generate({
    //   bindto: '#purchasesPerCategoryPie',
    //   data: {
    //     // iris data from R
    //     columns: [
    //       ['data1', 100],
    //       ['data2', 40],
    //     ],
    //     type: 'pie',
    //   },
    //   color: {
    //     pattern: [$.colors("primary", 500), $.colors("blue-grey", 200)]
    //   },
    //   legend: {
    //     position: 'right'
    //   },
    //   pie: {
    //     label: {
    //       show: false
    //     },
    //     onclick: function(d, i) {},
    //     onmouseover: function(d, i) {},
    //     onmouseout: function(d, i) {}
    //   }
    // });


  // Example Chartist Pie Chart Labels
  // ---------------------------------

    var labelsPieData = {
      labels: ["Produce", "Dairy", "Deli", "Frozen", "Grains", "Cans", "PersonalCare", "Bakery", "Other"],
      series: [1,2,1,2,1,2,1,2,1]
    };

    var labelsPieOptions = {
      labelInterpolationFnc: function(value) {
        return value[0];
      }
    };

    var labelsPieResponsiveOptions = [
      ['screen and (min-width: 640px)', {
        chartPadding: 0,
        labelOffset: 250,
        labelDirection: 'explode',
        labelInterpolationFnc: function(value) {
          return value;
        }
      }],
      ['screen and (min-width: 1024px)', {
        labelOffset: 80,
        chartPadding: 20
      }]
    ];

    new Chartist.Pie('#purchasesPerCategoryPie', labelsPieData, labelsPieOptions, labelsPieResponsiveOptions);

   	 

  	}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})



})


