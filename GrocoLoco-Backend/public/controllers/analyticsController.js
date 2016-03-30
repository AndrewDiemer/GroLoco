GrocoLoco.controller('analyticsController', function($scope, $http, $location) {


  $http.get("/averageGrocerySize").success(function(data,status){

    $('#averageListSize').text(data.Average.toPrecision(3));

  }).error(function(data, status){
      //something went wrong
      console.log(status)
      console.log(data)
    })

  $http.get("/averageGrocerySizeDistribution").success(function(data, status){

    var series = new Array(22);

    for( var i = 0; i<data.Distrubition.length; i++ )
    {
      series[i] = data.Distrubition[i];
    }

    var labels = new Array(21);

    for(var i = 0; i< 22; i++){
      labels[i] = i;
    }

    var overlappingData = {
     labels: labels,
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


  // Example Chartist Pie Chart Labels
  // ---------------------------------

  var labelsPieData = {
    labels: ["Produce", "Dairy", "Deli", "Frozen", "Grains", "Cans", "PersonalCare", "Bakery", "Other"],
    series: [
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
  };

  var labelsPieOptions = {
    labelInterpolationFnc: function(value) {
      return value[0];
    }
  };

  var labelsPieResponsiveOptions = [
  ['screen and (min-width: 640px)', {
    chartPadding: 50,
    labelOffset: 250,
    labelDirection: 'explode',
    labelInterpolationFnc: function(value) {
      return value;
    }
  }],
  ['screen and (min-width: 1024px)', {
    labelOffset: 100,
    height: 360,
    chartPadding: 20
  }]
  ];

  new Chartist.Pie('#purchasesPerCategoryPie', labelsPieData, labelsPieOptions, labelsPieResponsiveOptions);



}).error(function(data, status){
      //something went wrong
      console.log(status)
      console.log(data)
})

//TODO: Filter out the top ten most purchased items and only display those.
$http.get("/frequenciesOfItems").success(function(data,status){

  var dictArray = Object.keys(data).map(function(k) { return data[k] });

  var items = new Array(Object.getOwnPropertyNames(data).length)

  for( var i = 0; i < items.length; i++){
    items[i] = {
      Description : Object.getOwnPropertyNames(data)[i],
      value       : dictArray[i]
    }
  }

  var labels = new Array(items.length);
  var series = new Array(items.length);

  for(var i = 0; i< items.length; i++){
    labels[i] = items[i].Description
    series[i] = items[i].value
  }
  // console.log(labels);
  // console.log(series);

  var overlappingData = {
   labels: [labels],
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

 new Chartist.Bar('#frequencyOfItems', overlappingData, overlappingOptions, overlappingResponsiveOptions);


}).error(function(data, status){ 
      //something went wrong
      console.log(status)
      console.log(data)
})


$http.get("/numberOfUsers").success(function(data,status){

  $('#currentNumberOfUsers').text(data.Number);

}).error(function(data, status){ 
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})


$http.get("/getRecommendationBreakdown").success(function(data, status){


 var overlappingData = {
   labels: ["0-10%","11-20%","21-30%","31-40%","41-50%","51-60%","61-70%","71-80%","81-90%","91-100%"],
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

$http.get("/getRecommendationTotal").success(function(data,status){

  $('#recommendedItemsPerList').text(data.TotalBreakdown.toPrecision(3));

}).error(function(data, status){
  		//something went wrong
  		console.log(status)
  		console.log(data)
  	})








})


