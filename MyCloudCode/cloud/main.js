



// Initial query sent from search bar

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


// count number of times each unique primaryCategory shows up (based on categoryId), return top two


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

          var userCategory = ['9355']; 

          var AnyItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).some(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('Matches found: ' + AnyItemsOfCategoryResultsInUserCategory);

          var ItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).filter(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('User categories that match search: ' + ItemsOfCategoryResultsInUserCategory)



// if 1 match found -> default to those criteria -> send straight to matchcenter -> clear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=1, send search query with that categories saved info to ebay, display results in mc

// if >1 matches found -> ask which one  -> default to selected categories criteria  -> send to matchcenter -> clear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=2, send to intermed. page displaying ItemsOfCategoryResultsInUserCategory, search query with selected categories saved info to ebay, display results in mc

// if no matches found -> ask which category to use -> redirect to criteriaViewController  -> save the criteria user inputs  -> send to matchcenter -> cclear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=0, send to intermed. page displaying ItemsOfCategoryResultsInUserCategory, send selected category to CriteriaViewController, search query with selected categories saved info to ebay, display results in m



          response.success(AnyItemsOfCategoryResultsInUserCategory);

  },
          error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
          }
     });
});









// query sent from CriteriaViewController

Parse.Cloud.define("eBayCriteriaSearch", function(request, response) {
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



http://svcs.ebay.com/services/search/FindingService/v1?SECURITY-APPNAME=AndrewGh-2d30-4c8d-a9cd-248083bc4d0f&OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.0&RESPONSE-DATA-FORMAT=JSON&callback=_cb_findItemsByKeywords&REST-PAYLOAD&sortOrder=PricePlusShippingLowest&paginationInput.entriesPerPage=7&outputSelector=AspectHistogram&itemFilter(0).name=Condition&itemFilter(0).value(0)=New&itemFilter(1).name=MaxPrice&itemFilter(1).value=450.00&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&itemFilter(2).name=MinPrice&itemFilter(2).value=350.00&itemFilter(2).paramName=Currency&itemFilter(2).paramValue=USD&itemFilter(3).name=ListingType&itemFilter(3).value=FixedPrice&keywords=Moto+x+16gb+unlocked





     },
      success: function (httpResponse) {


// parses results

          var httpresponse = JSON.parse(httpResponse.text);
          var items = [];
          
          

// count number of times each unique primaryCategory shows up (based on categoryId), return top two


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

          var userCategory = ['9355']; 

          var AnyItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).some(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('Matches found: ' + AnyItemsOfCategoryResultsInUserCategory);

          var ItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).filter(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('User categories that match search: ' + ItemsOfCategoryResultsInUserCategory)



// if 1 match found -> default to those criteria -> send straight to matchcenter -> clear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=1, send search query with that categories saved info to ebay, display results in mc

// if >1 matches found -> ask which one  -> default to selected categories criteria  -> send to matchcenter -> clear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=2, send to intermed. page displaying ItemsOfCategoryResultsInUserCategory, search query with selected categories saved info to ebay, display results in mc

// if no matches found -> ask which category to use -> redirect to criteriaViewController  -> save the criteria user inputs  -> send to matchcenter -> cclear categoryResults and top2 array
          //ie. if ItemsOfCategoryResultsInUserCategory.length=0, send to intermed. page displaying ItemsOfCategoryResultsInUserCategory, send selected category to CriteriaViewController, search query with selected categories saved info to ebay, display results in m



          response.success(AnyItemsOfCategoryResultsInUserCategory);

  },
          error: function (httpResponse) {
              console.log('error!!!');
              response.error('Request failed with response code ' + httpResponse.status);
          }
     });
});





















// Parse.Cloud.define("userCategoryCriteria", function(request, response) {

// }

