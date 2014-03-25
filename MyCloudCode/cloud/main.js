
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});



Parse.Cloud.define("eBayCategorySearch", function(request, response) {
          url = 'http://svcs.ebay.com/services/search/FindingService/v1';

        Parse.Cloud.httpRequest({
            url: url,
            params: {
             'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f', 	
             'OPERATION-NAME' : 'findItemsByKeywords', 
             'SERVICE-VERSION' : '1.12.0', 
             'RESPONSE-DATA-FORMAT' : 'JSON', 
             'callback' : '_cb_findItemsByKeywords',
             'itemFilter(3).name=ListingType' : 'itemFilter(3).value=FixedPrice',
             'keywords' : 'request.params.item',

              // your other params
           },
            success: function (httpResponse) {
                console.log('eBay successfully pinged bro!');
            // deal with success and respond to query
},
            error: function (httpResponse) {
                console.log('error!!!');
                console.error('Request failed with response code ' + httpResponse.status);
            }
       });
});