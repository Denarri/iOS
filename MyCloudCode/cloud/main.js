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

                var matchingItemCategoryId = results[i].get("categoryId");
                console.log(matchingItemCategoryId);

                var matchingItemCondition = results[i].get("itemCondition");
                console.log(matchingItemCondition);

                var matchingItemLocation = results[i].get("itemLocation");
                console.log(matchingItemLocation);

                var matchingMinPrice = results[i].get("minPrice");
                console.log(matchingMinPrice);

                var matchingMaxPrice = results[i].get("maxPrice");
                console.log(matchingMaxPrice);

                var matchingItemSearch = request.params.item;
                console.log(matchingItemSearch);
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
               { "Matching Category Condition": matchingItemCondition }, 
                { "Matching Category Location": matchingItemLocation }, 
                { "Matching Category MaxPrice": matchingMaxPrice }, 
                { "Matching Category MinPrice": matchingMinPrice }, 
                { "Search Term": matchingItemSearch },
                { "Matching Category Id": matchingItemCategoryId },
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
          response.success('userCategory successfully created!');
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

  newMatchCenterItem.set("searchTerm", request.params.searchTerm);
  newMatchCenterItem.set("categoryId", request.params.categoryId);
  newMatchCenterItem.set("minPrice", request.params.minPrice);
  newMatchCenterItem.set("maxPrice", request.params.maxPrice);
  newMatchCenterItem.set("itemCondition", request.params.itemCondition);
  newMatchCenterItem.set("itemLocation", request.params.itemLocation);
  newMatchCenterItem.set("parent", Parse.User.current());
  newMatchCenterItem.save({ 

    success: function (){
      console.log ('MatchCenter Item successfully created!');
      response.success('MatchCenter Item successfully created!');
    },

    error: function (){
      console.log('error!!!');
    response.error('Request failed');
    }

  });


});


















//        'http://svcs.ebay.com/services/search/FindingService/v1?SECURITY-APPNAME=AndrewGh-2d30-4c8d-a9cd-248083bc4d0f&OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.0&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&sortOrder=PricePlusShippingLowest&paginationInput.entriesPerPage=7&outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)=New&itemFilter(1).name=MaxPrice&itemFilter(1).value=450.00&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&itemFilter(2).name=MinPrice&itemFilter(2).value=350.00&itemFilter(2).paramName=Currency&itemFilter(2).paramValue=USD&itemFilter(3).name=ListingType&itemFilter(3).value=FixedPrice&keywords=Moto+x+16gb+unlocked'







Parse.Cloud.define("MatchCenter", function(request, response) {

      //defines which parse class to iterate through
      var matchCenterItem = Parse.Object.extend("matchCenterItem");
      var query = new Parse.Query(matchCenterItem);

      //var promises = [];

      //setting the limit of items at 10 for now
      query.limit(10);
      query.find().then(function(results) {
        //the pinging ebay part

        for (i=0; i<results.length; i++) {
          var searchTerm = results[i].get('searchTerm');

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
             'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : results[i].get('itemCondition'),
             'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
             'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
             'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
             'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
             //'itemFilter(3).name=LocatedIn&itemFilter(3).Value' : request.params.itemLocation,
             'itemFilter(3).name=ListingType&itemFilter(3).value' : 'FixedPrice',
             'keywords' : results[i].get('searchTerm'),
            },
            success: function (httpResponse) {

              var httpresponse = JSON.parse(httpResponse.text);
              var matchCenterItems = [];
              
              //Parses through ebay's response, pushes each individual item and its properties into an array  
              httpresponse.findItemsByKeywordsResponse.forEach(function(itemByKeywordsResponse) {
                  itemByKeywordsResponse.searchResult.forEach(function(result) {
                    result.item.forEach(function(item) {
                      matchCenterItems.push(item);
                    });
                  });
              });

              var top3Titles = [];
              var top3Prices = [];
              var top3ImgURLS = [];
              var top3ItemURLS = [];

              

              //prelim. code, makes an array of the titles of the top 3 items
              //this will eventually be where the title, price, and img url are sent over to the app
              matchCenterItems.forEach(function(item) {
                var title = item.title[0];
                var price = item.sellingStatus[0].convertedCurrentPrice[0].__value__;
                var imgURL = item.galleryURL[0];
                var itemURL = item.viewItemURL[0];
                
                  
                top3Titles.push(title);
                top3Prices.push(price);
                top3ImgURLS.push(imgURL);
                top3ItemURLS.push(itemURL);
              });
                
              //console.log(top3Titles);

              //sends specifications of top3 to app  
              response.success(

                {"Top 3": 
                  [
                    { 
                      "Title": top3Titles[0], 
                      "Price": top3Prices[0], 
                      "Image URL": top3ImgURLS[0],
                      "Item URL": top3ItemURLS[0],
                      "Search Term": searchTerm
                    },
                  
                    { 
                      "Title": top3Titles[1], 
                      "Price": top3Prices[1], 
                      "Image URL": top3ImgURLS[1],
                      "Item URL": top3ItemURLS[1],
                      "Search Term": searchTerm
                    },
                  
                    { 
                      "Title": top3Titles[2], 
                      "Price": top3Prices[2], 
                      "Image URL": top3ImgURLS[2],
                      "Item URL": top3ItemURLS[2],
                      "Search Term": searchTerm
                    },
                  ]
                }

              );
              console.log('MatchCenter Pinged eBay dude!');
            },
            error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
            }
          });
        }
      });
});









Parse.Cloud.define("MatchCenterTest", function(request, response) {
    //defines which parse class to iterate through
    var matchCenterItem = Parse.Object.extend("matchCenterItem");
    var query = new Parse.Query(matchCenterItem);
    var promises = [];
    //setting the limit of items at 10 for now
    query.limit(10);
    query.find().then(function(results) {
        for (i=0; i<results.length; i++) {
            url = 'http://svcs.ebay.com/services/search/FindingService/v1';
            //push function containing criteria for every matchCenterItem into promises array
              promises.push(function() {
                return Parse.Cloud.httpRequest({
                  url: url,
                  params: {
                      'OPERATION-NAME' : 'findItemsByKeywords',
                      'SERVICE-VERSION' : '1.12.0',
                      'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
                      'GLOBAL-ID' : 'EBAY-US',
                      'RESPONSE-DATA-FORMAT' : 'JSON',
                      'REST-PAYLOAD&sortOrder' : 'BestMatch',
                      'paginationInput.entriesPerPage' : '3',
                      'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : results[i].get('itemCondition'),
                      'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
                      'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
                      'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
                      'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
                      //'itemFilter(3).name=LocatedIn&itemFilter(3).Value' : request.params.itemLocation,
                      'itemFilter(3).name=ListingType&itemFilter(3).value' : 'FixedPrice',
                      'keywords' : results[i].get('searchTerm'),
                  }
                });
              });
        }
        Parse.Promise.when(promises).then(function() {
          var results = arguments;
          for (i=0; i<results.length; i++)
          {
            console.log(results[i]); // So you can see what the response 
                                     // looks like for each httpRequest that was made
          }
          // and by the way if this is the end of your function, then here you can call
          response.success(results);
        }, function(err) {
                  console.log('error!');
                  response.error();
           });
    });
});















//             success: function (httpResponse) {

//               var httpresponse = JSON.parse(httpResponse.text);
//               var matchCenterItems = [];
              
//               //Parses through ebay's response, pushes each individual item and its properties into an array  
//               httpresponse.findItemsByKeywordsResponse.forEach(function(itemByKeywordsResponse) {
//                   itemByKeywordsResponse.searchResult.forEach(function(result) {
//                     result.item.forEach(function(item) {
//                       matchCenterItems.push(item);
//                     });
//                   });
//               });

//               var top3Titles = [];
//               var top3Prices = [];
//               var top3ImgURLS = [];
//               var top3ItemURLS = [];

//               //prelim. code, makes an array of the titles of the top 3 items
//               //this will eventually be where the title, price, and img url are sent over to the app
//               matchCenterItems.forEach(function(item) {
//                 var title = item.title[0];
//                 var price = item.sellingStatus[0].convertedCurrentPrice[0].__value__;
//                 var imgURL = item.galleryURL[0];
//                 var itemURL = item.viewItemURL[0];
                  
//                 top3Titles.push(title);
//                 top3Prices.push(price);
//                 top3ImgURLS.push(imgURL);
//                 top3ItemURLS.push(itemURL);
//               });
                
//               //console.log(top3Titles);

//               //sends specifications of top3 to app  
//               response.success(

//                 {"Top 3": 
//                   [
//                     { 
//                       "Title": top3Titles[0], 
//                       "Price": top3Prices[0], 
//                       "Image URL": top3ImgURLS[0],
//                       "Item URL": top3ItemURLS[0]
//                     },
                  
//                     { 
//                       "Title": top3Titles[1], 
//                       "Price": top3Prices[1], 
//                       "Image URL": top3ImgURLS[1],
//                       "Item URL": top3ItemURLS[1]
//                     },
                  
//                     { 
//                       "Title": top3Titles[2], 
//                       "Price": top3Prices[2], 
//                       "Image URL": top3ImgURLS[2],
//                       "Item URL": top3ItemURLS[2]
//                     },
//                   ]
//                 }

//               );
//               console.log('MatchCenter Pinged eBay dude!');
//             },
//             error: function (httpResponse) {
//               console.log('error!!!');
//               response.error('Request failed with response code ' + httpResponse.status);
//             }
//           //}));
//         }
//       });
// });






Parse.Cloud.define("deleteFromMatchCenter", function(request, response) {

  var matchCenterItem = Parse.Object.extend("matchCenterItem");
  var query = new Parse.Query(matchCenterItem);

  query.contains('searchTerm', request.params.searchTerm);
  query.equalTo('parent', Parse.User.current())

  query.find().then(function(matchCenterItem) {
    return Parse.Object.destroyAll(matchCenterItem);
  }).then(function(success) {
    response.success('MatchCenterItem removed!')
  }, function(error) {
    response.error('MatchCenterItem Unable to be removed!');
  });

});


