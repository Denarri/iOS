// Creation of initial userCategory object upon user signup

Parse.Cloud.define("userCategoryCreate", function(request, response) {
    var userCategory = Parse.Object.extend("userCategory");
    var newUserCategory = new userCategory();
    newUserCategory.set("categoryId", "");
    newUserCategory.set("minPrice");
    newUserCategory.set("maxPrice");
    newUserCategory.set("itemCondition");
    newUserCategory.set("itemLocation");
    newUserCategory.set("parent", Parse.User.current());
    newUserCategory.save({ 

      success: function (){
        console.log ('userCategory successfully created!');
        response.success('Request successful');
      },

      error: function (){
        console.log('error!!!');
      response.error('Request failed');
      }

    });
});














// Query sent from search bar

Parse.Cloud.define("eBayCategorySearch", function(request, response) {
          url = 'http://svcs.ebay.com/services/search/FindingService/v1';

  Parse.Cloud.httpRequest({
      url: url,
      params: { 	
       'OPERATION-NAME' : 'findItemsByKeywords', 
       'SERVICE-VERSION' : '1.12.0',
       'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
       'GLOBAL-ID' : 'EBAY-US',
       'RESPONSE-DATA-FORMAT' : 'JSON',
       'itemFilter(0).name=ListingType' : 'itemFilter(0).value=FixedPrice',
       'keywords' : request.params.item,

     },
      success: function (httpResponse) {


  // parses results

          var httpresponse = JSON.parse(httpResponse.text);
          var items = [];
          
          httpresponse.findItemsByKeywordsResponse.forEach(function(itemByKeywordsResponse) {
            itemByKeywordsResponse.searchResult.forEach(function(result) {
              result.item.forEach(function(item) {
                items.push(item);
              });
            });
          });


  // count number of times each unique primaryCategory shows up (based on categoryId), returns top two


          var categoryResults = {};

          items.forEach(function(item) {
            var id = item.primaryCategory[0].categoryId;
            if (categoryResults[id]) categoryResults[id]++;
            else categoryResults[id] = 1;
          });

          var top2 = Object.keys(categoryResults).sort(function(a, b) 
            {return categoryResults[b]-categoryResults[a]; }).slice(0, 2);
          console.log('Top categories: ' + top2.join(', '));



  // compare categoryResults to userCategory object

          //Extend the Parse.Object class to make the ListItem class
          var userCategory = Parse.Object.extend("userCategory");
 
          //Use Parse.Query to generate a new query, specifically querying the userCategory object.
          query = new Parse.Query(userCategory);
           
          //Set constraints on the query.
          query.containedIn('categoryId', top2);
          query.equalTo("User", Parse.User.current())

          //Submit the query and pass in callback functions.
          var isMatching = false;
          query.find({
            success: function(results) {
              var userCategoriesMatchingTop2 = results;
              console.log("userCategory comparison success!");
              console.log(results);
              if (userCategoriesMatchingTop2 && userCategoriesMatchingTop2.length > 0) {
                isMatching = true;
              }

              response.success({
                "results": [
                  { "Number of top categories": top2.length },
                            { "Top categories": top2 },  
                         { "Number of matches": userCategoriesMatchingTop2.length }, 
         { "User categories that match search": userCategoriesMatchingTop2 }
                ]
              }

                //'Number of top categories: ' + top2.length + 'Number of matches: ' + userCategoriesMatchingTop2.length + ' User categories that match search: ' + userCategoriesMatchingTop2

              );

              console.log('User categories that match search: ' + results)
            },
            error: function(error) {
              //Error Callback
              console.log("An error has occurred");
              console.log(error);
            }
          });
  },
          error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
          }
     });
});




















// Adds criteria info to userCategory object

// Parse.Cloud.define("userCategorySave", function(request, response) {



// }


















// query sent from MatchCenterViewController

Parse.Cloud.define("eBayMatchCenterSearch", function(request, response) {
          url = 'http://svcs.ebay.com/services/search/FindingService/v1';

  Parse.Cloud.httpRequest({
      url: url,
      params: {   
       'OPERATION-NAME' : 'findItemsByKeywords', 
       'SERVICE-VERSION' : '1.12.0',
       'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
       'GLOBAL-ID' : 'EBAY-US',
       'RESPONSE-DATA-FORMAT' : 'JSON',
       'itemFilter(0).name=ListingType' : 'itemFilter(0).value=FixedPrice',
       'sortOrder' : 'PricePlusShippingLowest',
       'paginationInput.entriesPerPage' : '3',
       'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : request.params.itemCondition,
       'itemFilter(1).name=MaxPrice&itemFilter(1).value' : request.params.maxPrice,
       'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
       'itemFilter(2).name=MinPrice&itemFilter(2).value' : request.params.minPrice,
       'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
       'keywords' : request.params.item,


     },
      success: function (httpResponse) {


// parses results

          var httpresponse = JSON.parse(httpResponse.text);
          

          response.success(AnyItemsOfCategoryResultsInUserCategory);

  },
          error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
          }
     });
});

