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







var itemLocation;
var promise; // variable holding the promise


// Query sent from search bar

Parse.Cloud.define("eBayCategorySearch", function(request, response) {
          url = 'http://svcs.ebay.com/services/search/FindingService/v1';

  promise = Parse.Cloud.httpRequest({
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


  // count number of times each unique primaryCategory shows up (based on categoryId), returns top two IDs and their respective names


          var categoryIdResults = {};

          // Collect two most frequent categoryIds
          items.forEach(function(item) {
            var id = item.primaryCategory[0].categoryId;
            if (categoryIdResults[id]) categoryIdResults[id]++;
            else categoryIdResults[id] = 1;
          });

          var top2 = Object.keys(categoryIdResults).sort(function(a, b) 
            {return categoryIdResults[b]-categoryIdResults[a]; }).slice(0, 2);
          console.log('Top category Ids: ' + top2.join(', '));


          var categoryNameResults = {};

          // Collect two most frequent categoryNames  
          items.forEach(function(item) {
            var categoryName = item.primaryCategory[0].categoryName;
            if (categoryNameResults[categoryName]) categoryNameResults[categoryName]++;
            else categoryNameResults[categoryName] = 1;
          });  


          var top2Names = Object.keys(categoryNameResults).sort(function(a, b) 
            {return categoryNameResults[b]-categoryNameResults[a]; }).slice(0, 2);
          console.log('Top category Names: ' + top2Names.join(', '));



  // compare categoryIdResults to userCategory object

          //Extend the Parse.Object class to make the userCategory class
          var userCategory = Parse.Object.extend("userCategory");
 
          //Use Parse.Query to generate a new query, specifically querying the userCategory object.
          query = new Parse.Query(userCategory);
           
          //Set constraints on the query.
          query.containedIn('categoryId', top2);
          query.equalTo('parent', Parse.User.current())

          //Submit the query and pass in callback functions.
          var isMatching = false;
          query.find({
            success: function(results) {
              var userCategoriesMatchingTop2 = results;
              console.log("userCategory comparison success!");
              console.log(results);


              for (var i = 0; i < results.length; i++) 
              {
                itemCondition = results[i].get("itemCondition");
                console.log(itemCondition);

                itemLocation = results[i].get("itemLocation");
                console.log(itemLocation);

                minPrice = results[i].get("minPrice");
                console.log(minPrice);

                maxPrice = results[i].get("maxPrice");
                console.log(maxPrice);

                itemSearch = request.params.item;
                console.log(itemSearch);
               }



              if (userCategoriesMatchingTop2 && userCategoriesMatchingTop2.length > 0) {
                isMatching = true;
              }

              response.success({
                "results": [
                  { "Number of top categories": top2.length },
                          { "Top category Ids": top2 },
                        { "Top category names": top2Names },   
                         { "Number of matches": userCategoriesMatchingTop2.length }, 
         { "User categories that match search": userCategoriesMatchingTop2 }, 
               { "Matching Category Condition": itemCondition }, 
                { "Matching Category Location": itemLocation }, 
                { "Matching Category MaxPrice": maxPrice }, 
                { "Matching Category MinPrice": minPrice }, 
                { "Search Term": itemSearch }, 

                ]
              });

              console.log('User categories that match search: ', results);
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



//promise.then(function(resp){
//    console.log(itemLocation);
//});








// Adds criteria info to userCategory object
Parse.Cloud.define("userCategorySave", function(request, response) {


  var userCategory = Parse.Object.extend("userCategory");
  var newUserCategory = new userCategory();
      newUserCategory.set("categoryId", request.params.categoryId);
      newUserCategory.set("minPrice", request.params.minPrice);
      newUserCategory.set("maxPrice", request.params.maxPrice);
      newUserCategory.set("itemCondition", request.params.itemCondition);
      newUserCategory.set("itemLocation", request.params.itemLocation);
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
















// Add new item to MatchCenter Array with the criteria from userCategory instance, plus the search term
Parse.Cloud.define("addToMatchCenter", function(request, response) {


var matchCenterItem = Parse.Object.extend("matchCenterItem");
    var newMatchCenterItem = new matchCenterItem();

    newUserCategory.set("searchTerm");
    newUserCategory.set("categoryId");
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


















//        'http://svcs.ebay.com/services/search/FindingService/v1?SECURITY-APPNAME=AndrewGh-2d30-4c8d-a9cd-248083bc4d0f&OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.0&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&sortOrder=PricePlusShippingLowest&paginationInput.entriesPerPage=7&outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)=New&itemFilter(1).name=MaxPrice&itemFilter(1).value=450.00&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&itemFilter(2).name=MinPrice&itemFilter(2).value=350.00&itemFilter(2).paramName=Currency&itemFilter(2).paramValue=USD&itemFilter(3).name=ListingType&itemFilter(3).value=FixedPrice&keywords=Moto+x+16gb+unlocked'







//forEach item in MatchCenter Array, do the stuff below
Parse.Cloud.define("MatchCenter", function(request, response) {


          url = 'http://svcs.ebay.com/services/search/FindingService/v1';

  Parse.Cloud.httpRequest({
      url: url,
      params: {   
       'OPERATION-NAME' : 'findItemsByKeywords', 
       'SERVICE-VERSION' : '1.12.0',
       'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
       'GLOBAL-ID' : 'EBAY-US',
       'RESPONSE-DATA-FORMAT' : 'JSON',
       'REST-PAYLOAD&sortOrder' : 'BestMatch',
       'paginationInput.entriesPerPage' : '3',
       'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : request.params.itemCondition,
       'itemFilter(1).name=MaxPrice&itemFilter(1).value' : request.params.maxPrice,
       'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
       'itemFilter(2).name=MinPrice&itemFilter(2).value' : request.params.minPrice,
       'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
       //'itemFilter(3).name=LocatedIn&itemFilter(3).Value' : request.params.itemLocation,
       'itemFilter(3).name=ListingType&itemFilter(3).value' : 'FixedPrice',
       'keywords' : request.params.item,


     },
      success: function (httpResponse) {


// parses results

          var httpresponse = JSON.parse(httpResponse.text);

          response.success(httpresponse);
          console.log('MatchCenter Pinged eBay dude!');

  },
          error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
          }
     });
});


