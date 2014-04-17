



// Sends search query to eBay

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

          var userCategory = []; 

          var AnyItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).some(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('Matches found: ' + AnyItemsOfCategoryResultsInUserCategory);

          var ItemsOfCategoryResultsInUserCategory = Object.keys(categoryResults).filter(function(item) {
            return userCategory.indexOf(item) > -1;
          });
          console.log('User categories that match search: ' + ItemsOfCategoryResultsInUserCategory)



// if 1 match found -> default to those criteria -> send straight to matchcenter -> clear categoryResults and top2 array
          
// if >1 matches found -> ask which one  -> default to selected categories criteria  -> send to matchcenter -> clear categoryResults and top2 array

// if no matches found -> ask which category to use -> redirect to criteriaViewController  -> save the criteria user inputs  -> send to matchcenter -> cclear categoryResults and top2 array


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

