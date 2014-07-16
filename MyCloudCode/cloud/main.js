// Creation of initial userCategory object upon user signup

Parse.Cloud.define("userCategoryCreate", function(request, response) {
    var userCategory = Parse.Object.extend("userCategory");
    var newUserCategory = new userCategory();
    newUserCategory.set("categoryId", "");
    newUserCategory.set("categoryName");
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



Parse.Cloud.define("mcComparisonArrayCreate", function(request, response) {
    var mComparisonArray = Parse.Object.extend("mComparisonArray");
    var newMComparisonArray = new mComparisonArray();
    newMComparisonArray.set("Name", "MatchCenter");
    newMComparisonArray.set("MCItems","" );
    newMComparisonArray.set("parent", Parse.User.current());
    newMComparisonArray.save({ 

      success: function (){
        console.log ('newMComparisonArray successfully created!');
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
              
              if (userCategoriesMatchingTop2.length > 0) {

                var matchingItemCategoryId1 = results[0].get("categoryId");
                console.log(matchingItemCategoryId1);

                var matchingItemCondition1 = results[0].get("itemCondition");
                console.log(matchingItemCondition1);
                
                var matchingItemLocation1 = results[0].get("itemLocation");
                console.log(matchingItemLocation1);

                var matchingMinPrice1 = results[0].get("minPrice");
                console.log(matchingMinPrice1);

                var matchingMaxPrice1 = results[0].get("maxPrice");
                console.log(matchingMaxPrice1);

                var matchingItemSearch = request.params.item;
                console.log(matchingItemSearch);

                var matchingCategoryName1 = results[0].get("categoryName");
                console.log(matchingCategoryName1);

                if (userCategoriesMatchingTop2.length > 1) {

                  var matchingItemCategoryId2 = results[1].get("categoryId");
                    console.log(matchingItemCategoryId2);
                  var matchingItemCondition2 = results[1].get("itemCondition");
                    console.log(matchingItemCondition2);
                  var matchingItemLocation2 = results[1].get("itemLocation");
                    console.log(matchingItemLocation2);
                  var matchingMinPrice2 = results[1].get("minPrice");
                    console.log(matchingMinPrice2);
                  var matchingMaxPrice2 = results[1].get("maxPrice");
                    console.log(matchingMaxPrice2);
                  var matchingCategoryName2 = results[1].get("categoryName");
                    console.log(matchingCategoryName2);

                }

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
               { "Matching Category Condition 1": matchingItemCondition1 }, 
               { "Matching Category Condition 2": matchingItemCondition2 }, 
                { "Matching Category Location 1": matchingItemLocation1 },
                { "Matching Category Location 2": matchingItemLocation2 }, 
                { "Matching Category MaxPrice 1": matchingMaxPrice1 },
                { "Matching Category MaxPrice 2": matchingMaxPrice2 }, 
                { "Matching Category MinPrice 1": matchingMinPrice1 },
                { "Matching Category MinPrice 2": matchingMinPrice2 }, 
                { "Search Term": matchingItemSearch },
                { "Matching Category Id 1": matchingItemCategoryId1 },
                { "Matching Category Id 2": matchingItemCategoryId2 },
                { "Matching Category Name 1": matchingCategoryName1 },
                { "Matching Category Name 2": matchingCategoryName2 },
                ]
              });
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
      newUserCategory.set("categoryName", request.params.categoryName);
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








Parse.Cloud.define("MatchCenter", function(request, response) {
    //defines which parse class to iterate through
    var matchCenterItem = Parse.Object.extend("matchCenterItem");
    var query = new Parse.Query(matchCenterItem);
    query.equalTo('parent', Parse.User.current())
    
    var promises = [];
    var searchTerms = [];

    //setting the limit of items at 10 for now
    query.limit(10);
    query.find().then(function(results) {
      for (i=0; i<results.length; i++) {

        // ... later in your loop where you populate promises:
        var searchTerm = results[i].get('searchTerm');
        // add it to the array just like you add the promises:
        searchTerms.push(searchTerm);

        url = 'http://svcs.ebay.com/services/search/FindingService/v1';
        //push function containing criteria for every matchCenterItem into promises array
        promises.push((function() {
          
          if (results[i].get('itemLocation') == 'US')
          {
            console.log('americuh!');
            var httpRequestPromise = Parse.Cloud.httpRequest({
              url: url,
              params: { 
                'OPERATION-NAME' : 'findItemsByKeywords',
                'SERVICE-VERSION' : '1.12.0',
                'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
                'GLOBAL-ID' : 'EBAY-US',
                'RESPONSE-DATA-FORMAT' : 'JSON',
                'REST-PAYLOAD&sortOrder' : 'BestMatch',
                'paginationInput.entriesPerPage' : '3',
                'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : 'New',
                'itemFilter(0).value(1)' : results[i].get('itemCondition'),
                'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
                'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
                'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
                'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
                'itemFilter(3).name=LocatedIn&itemFilter(3).value' : 'US',
                'itemFilter(4).name=ListingType&itemFilter(4).value' : 'FixedPrice',
                'keywords' : results[i].get('searchTerm'),
              }
            });
          }

          else if (results[i].get('itemLocation') == 'WorldWide')
          {
            console.log('Mr worlwide!');
            var httpRequestPromise = Parse.Cloud.httpRequest({
              url: url,
              params: { 
                'OPERATION-NAME' : 'findItemsByKeywords',
                'SERVICE-VERSION' : '1.12.0',
                'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
                'GLOBAL-ID' : 'EBAY-US',
                'RESPONSE-DATA-FORMAT' : 'JSON',
                'REST-PAYLOAD&sortOrder' : 'BestMatch',
                'paginationInput.entriesPerPage' : '3',
                'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : 'New',
                'itemFilter(0).value(1)' : results[i].get('itemCondition'),
                'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
                'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
                'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
                'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
                // 'itemFilter(3).name=LocatedIn&itemFilter(3).value' : 'US',
                'itemFilter(3).name=ListingType&itemFilter(3).value' : 'FixedPrice',
                'keywords' : results[i].get('searchTerm'),
              }
            });
          }

          return httpRequestPromise
        })());
      }
  

      //when finished pushing all the httpRequest functions into promise array, do the following  
      Parse.Promise.when(promises).then(function(results){

        var eBayResults = [];

        for (var i = 0; i < arguments.length; i++) {
          var httpResponse = arguments[i];
          // since they're in the same order, this is OK:
          var searchTerm = searchTerms[i];
          // pass it as a param:
          var top3 = collectEbayResults(httpResponse.text, searchTerm)
          eBayResults.push(top3);
        };

        function collectEbayResults (eBayResponseText, searchTerm) {
          var ebayResponse = JSON.parse(eBayResponseText)

          var matchCenterItems = [];
              
              //Parses through ebay's response, pushes each individual item and its properties into an array  
              ebayResponse.findItemsByKeywordsResponse.forEach(function(itemByKeywordsResponse) {
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

              //where the title, price, and img url are sent over to the app
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


              var top3 = 
              {
                "Top 3": 
                [

                    { 
                      "Title": top3Titles[0], 
                      "Price": top3Prices[0], 
                      "Image URL": top3ImgURLS[0],
                      "Item URL": top3ItemURLS[0]
                    },
                  
                    { 
                      "Title": top3Titles[1], 
                      "Price": top3Prices[1], 
                      "Image URL": top3ImgURLS[1],
                      "Item URL": top3ItemURLS[1]
                    },
                  
                    { 
                      "Title": top3Titles[2], 
                      "Price": top3Prices[2], 
                      "Image URL": top3ImgURLS[2],
                      "Item URL": top3ItemURLS[2]
                    },

                    {
                       "Search Term": searchTerm
                    }
                ]
              }
              return top3
        }

        response.success
        (
          eBayResults
        );

      }, function(err) {
          console.log('error!');
          response.error('DAMN IT MAN');
          });
    });
});















// Parse.Cloud.job("MatchCenterBackground", function(request, status) {
//     //defines which parse class to iterate through
//     var matchCenterItem = Parse.Object.extend("matchCenterItem");
//     var query = new Parse.Query(matchCenterItem);
//     var promises = [];
//     var searchTerms = [];

//     //setting the limit of items at 10 for now
//     query.limit(10);
//     query.find().then(function(results) {
//       for (i=0; i<results.length; i++) {

//         // ... later in your loop where you populate promises:
//         var searchTerm = results[i].get('searchTerm');
//         // add it to the array just like you add the promises:
//         searchTerms.push(searchTerm);

//         url = 'http://svcs.ebay.com/services/search/FindingService/v1';
//         //push function containing criteria for every matchCenterItem into promises array
//         promises.push((function() {
          
//           if (results[i].get('itemLocation') == 'US')
//           {
//             console.log('americuh!');
//             var httpRequestPromise = Parse.Cloud.httpRequest({
//               url: url,
//               params: { 
//                 'OPERATION-NAME' : 'findItemsByKeywords',
//                 'SERVICE-VERSION' : '1.12.0',
//                 'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
//                 'GLOBAL-ID' : 'EBAY-US',
//                 'RESPONSE-DATA-FORMAT' : 'JSON',
//                 'REST-PAYLOAD&sortOrder' : 'BestMatch',
//                 'paginationInput.entriesPerPage' : '3',
//                 'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : 'New',
//                 'itemFilter(0).value(1)' : results[i].get('itemCondition'),
//                 'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
//                 'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
//                 'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
//                 'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
//                 'itemFilter(3).name=LocatedIn&itemFilter(3).value' : 'US',
//                 'itemFilter(4).name=ListingType&itemFilter(4).value' : 'FixedPrice',
//                 'keywords' : results[i].get('searchTerm'),
//               }
//             });
//           }

//           else if (results[i].get('itemLocation') == 'WorldWide')
//           {
//             console.log('Mr worlwide!');
//             var httpRequestPromise = Parse.Cloud.httpRequest({
//               url: url,
//               params: { 
//                 'OPERATION-NAME' : 'findItemsByKeywords',
//                 'SERVICE-VERSION' : '1.12.0',
//                 'SECURITY-APPNAME' : 'AndrewGh-2d30-4c8d-a9cd-248083bc4d0f',
//                 'GLOBAL-ID' : 'EBAY-US',
//                 'RESPONSE-DATA-FORMAT' : 'JSON',
//                 'REST-PAYLOAD&sortOrder' : 'BestMatch',
//                 'paginationInput.entriesPerPage' : '3',
//                 'outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)' : 'New',
//                 'itemFilter(0).value(1)' : results[i].get('itemCondition'),
//                 'itemFilter(1).name=MaxPrice&itemFilter(1).value' : results[i].get('maxPrice'),
//                 'itemFilter(1).paramName=Currency&itemFilter(1).paramValue' : 'USD',
//                 'itemFilter(2).name=MinPrice&itemFilter(2).value' : results[i].get('minPrice'),
//                 'itemFilter(2).paramName=Currency&itemFilter(2).paramValue' : 'USD',
//                 // 'itemFilter(3).name=LocatedIn&itemFilter(3).value' : 'US',
//                 'itemFilter(3).name=ListingType&itemFilter(3).value' : 'FixedPrice',
//                 'keywords' : results[i].get('searchTerm'),
//               }
//             });
//           }

//           return httpRequestPromise
//         })());
//       }
  

//       //when finished pushing all the httpRequest functions into promise array, do the following  
//       Parse.Promise.when(promises).then(function(results){

//         var eBayResults = [];

//         for (var i = 0; i < arguments.length; i++) {
//           var httpResponse = arguments[i];
//           // since they're in the same order, this is OK:
//           var searchTerm = searchTerms[i];
//           // pass it as a param:
//           var top3 = collectEbayResults(httpResponse.text, searchTerm)
//           eBayResults.push(top3);
//         };

//         function collectEbayResults (eBayResponseText, searchTerm) {
//           var ebayResponse = JSON.parse(eBayResponseText)

//           var matchCenterItems = [];
              
//               //Parses through ebay's response, pushes each individual item and its properties into an array  
//               ebayResponse.findItemsByKeywordsResponse.forEach(function(itemByKeywordsResponse) {
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

//               //where the title, price, and img url are sent over to the app
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


//               var top3 = 
//               {
//                 "Top 3": 
//                 [
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

//                     {
//                        "Search Term": searchTerm
//                     }
//                 ]
//               }
//               return top3








//                 //psuedocode
//                 /*

//                 */











//                   var mComparisonArray = Parse.Object.extend("MComparisonArray");
//                   var query = new Parse.Query(mComparisonArray);

//                   query.contains('Name', 'MatchCenter');
//                   query.contains('MCItems', eBayResults);
//                   query.equalTo('parent', Parse.User.current())

//                   //
//                   var matcheseBayResults = false;



//                   query.find({success: function(results) {
//                     if (matcheseBayResults = false){
//                        //if false, replace MCItems array content with eBayResults, and send push notif.
//                     }
              
//                   if (results.length > 0) {}

                  
                   

//                   }).then(function(success) {
//                     response.success('MatchCenter Comparison Success!')
//                   }, function(error) {
//                     response.error('CRAP!');
//                   });
            




//         }

//         status.success
//         (
//           'background job worked brah!'
//         );

//       }, function(err) {
//           console.log('error!');
//           status.error('DAMN IT MAN');
//           });
//     });

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