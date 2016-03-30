

var client = require('twilio')('AC79fdf699e64723f19756fb9df961697e', 'e2487ce2398c52c691e34b11966bca25');



module.exports = function(app){

	app.post('/sendText', function(req,res){
		console.log('Sending Text')
		var phoneNumberSender = req.body.PhoneNumber
		var list = req.body.List
		var listString = ''
		listString += 'Grocery Store: ' + req.body.GroceryStore + "\n"
 
		for (var i = 0; i < list.length; i++)
			listString += (i+1) + ') ' + list[i] + '\n'
		
		client.sendMessage({
		    to:'+' +phoneNumberSender, // Any number Twilio can deliver to
		    from: '+15878012284', // A number you bought from Twilio and can use for outbound communication
		    body: listString // body of the SMS message

		}, function(err, responseData) { //this function is executed when a response is received from Twilio

		    if (!err) { // "err" is an error received during the request, if any

		        // "responseData" is a JavaScript object containing data received from Twilio.
		        // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
		        // http://www.twilio.com/docs/api/rest/sending-sms#example-1

		        console.log(responseData.from); // outputs "+14506667788"
		        console.log(responseData.body); // outputs "word to your mother."

		    }else{
		    	console.log(err)
		    }
		});

	})

	//Send an SMS text message
	


}