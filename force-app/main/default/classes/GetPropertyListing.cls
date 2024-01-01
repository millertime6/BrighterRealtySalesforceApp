global class GetPropertyListing {

  // Pass in the endpoint to be used using the string url
  @future (callout=true)
  @auraEnabled
   Webservice static void getPropertyListingData(String subjectPropertyId) {
    
    System.debug('Subject Property Id from LWC ' +subjectPropertyId); 
    List<Property__c> propertyList = [SELECT Name, Id, Value_Estimate__c, Full_Address__c,Latitude__c, Longitude__c, Property_Picture_Link__c, Property_Type__c, Non_Owner_Occupied__c, Last_Sale_Date__c, Status__c, Listing_Status__c, Baths__c, Beds__c, County__c, Rent_Estimate__c, Monthly_HOA_Fee__c
                                      FROM Property__c WHERE Id =: subjectPropertyId]; 
    system.debug('the property list is: '+propertyList); 

      Property__c subjectProperty; 
      subjectProperty = propertyList[0]; 
          

      //update url 
      Map<String, Property_API_Key__mdt> apiMap = Property_API_Key__mdt.getAll();
      system.debug('apiMap: '+apiMap);
      system.debug(apiMap.get('api_key'));
      String apiKeyString = string.valueOf(apiMap.get('api_key'));
      String apiKey = apiKeyString.substringAfter('zillow_api_key__c=').substringBefore(','); 
      system.debug('api key: '+apiKey);
      String propertyAddressToUpdate = subjectProperty.Full_Address__c; 
      //url encode property address
      String urlEncodedPropertyAddress = EncodingUtil.urlEncode(propertyAddressToUpdate, 'UTF-8');
      system.debug('URL Encoded property: '+String.valueOf(urlEncodedPropertyAddress)); 
      String paddedPropertyAddress = '/search_address?address='+urlEncodedPropertyAddress; 
  
      // Instantiate a new Http object
      Http h = new Http();
  
      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setMethod('GET');
      req.setHeader('X-RapidAPI-Key', apiKey); 
      req.setHeader('X-RapidAPI-Host','zillow56.p.rapidapi.com'); 
      req.setEndpoint('callout:ZillowPropertySearch'+paddedPropertyAddress);
  
      // Send the request, and return a response
      HttpResponse res = h.send(req);
      Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
      List<Property__c> updateProperty = PropertyDataUpdate.processPropertyCallout(subjectProperty,m); 

      //check and make sure proper status response 
      if(res.getStatusCode() == 200) {

        //populating the results 
        Map<String,String> updateMap = new Map<String, String>(); 
        subjectProperty.Response_Message__c = PropertyUpdateFromZillow.getResponseMessage(res.getStatusCode())+', error code= '+PropertyUpdateFromZillow.getError(m); 

        update updateProperty[0]; 

    }else{
      system.debug('There was a status error. '); 
      subjectProperty.Response_Message__c = 'There was a status error with response code: '+res.getStatusCode()+' '+PropertyUpdateFromZillow.getResponseMessage(res.getStatusCode()); 
      updateProperty.add(subjectProperty); 
      update updateProperty; 
    }
  }
}