global class GetPropertyListing {

    // Pass in the endpoint to be used using the string url
    @auraEnabled
     Webservice static void getPropertyListingData(String subjectPropertyId) {
      
      List<Property__c> propertyList = [SELECT Name, Id, Baths__c, Beds__c, County__c FROM Property__c WHERE Id =: subjectPropertyId]; 
      system.debug('the property list is: '+propertyList); 

      Property__c subjectProperty; 
      try {
        subjectProperty = propertyList[0]; 
      
        //update url 
        String apiKey = '0ce8a0f686mshe96e68bade03161p19224cjsnba5566686949'; 
        String propertyAddressToUpdate = subjectProperty.Full_Address__c; 
        String paddedPropertyAddress = '/search?location='+propertyAddressToUpdate.replace(' ','%20').replace(',',''); 
    
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
        //create separate class to hold mapped values 
        //create instance of the class here 
        //update instance values with mapped results from callout response 
        
        System.debug(m); 
        for(String s: m.keySet()){
            system.debug(m.get(s)); 
        }

        //populating the results 
        Map<String,String> updateMap = new Map<String, String>(); 

        String bathrooms = PropertyUpdateFromZillow.parseStringAfter(('bathrooms: '+m.get('bathrooms'))); 
        updateMap.put('bathrooms',bathrooms); 
        String bedrooms = PropertyUpdateFromZillow.parseStringAfter(('bedrooms: '+m.get('bedrooms'))); 
        updateMap.put('bedrooms',bedrooms); 
        String city = PropertyUpdateFromZillow.parseStringAfter(('city: '+m.get('city'))); 
        updateMap.put('city',city); 
        String cityId = PropertyUpdateFromZillow.parseStringAfter(('cityId: '+m.get('cityId'))); 
        updateMap.put('cityId',cityId); 
        String county = PropertyUpdateFromZillow.parseStringAfter(('county: '+m.get('county'))); 
        updateMap.put('county',county); 
        String dateSoldString = PropertyUpdateFromZillow.parseStringAfter(('dateSoldString: '+m.get('dateSoldString'))); 
        updateMap.put('dateSoldString',dateSoldString); 

        //testing the values 
        system.debug(bathrooms); 
        system.debug(bedrooms); 
        system.debug(city); 
        system.debug(cityId); 
        system.debug(county); 
        system.debug(dateSoldString); 

        subjectProperty.Baths__c = Decimal.valueOf(bathrooms); 
        subjectProperty.Beds__c = Decimal.valueOf(bedrooms); 
        subjectProperty.county__c = county; 

        system.debug(updateMap); 
      }
      catch (Exception e) {
        System.debug('There were no properties in that criteria. '); 
      }
    }
  }
