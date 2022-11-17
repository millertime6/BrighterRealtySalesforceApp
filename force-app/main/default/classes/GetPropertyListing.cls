global class GetPropertyListing {

    // Pass in the endpoint to be used using the string url
    @auraEnabled
     Webservice static void getPropertyListingData(String subjectPropertyId) {
      
      System.debug('Subject Property Id from LWC ' +subjectPropertyId); 
      List<Property__c> propertyList = [SELECT Name, Id, Value_Estimate__c, Full_Address__c,Latitude__c, Longitude__c, Property_Picture_Link__c, Property_Type__c, Non_Owner_Occupied__c, Last_Sale_Date__c, Status__c, Listing_Status__c, Baths__c, Beds__c, County__c 
                                        FROM Property__c WHERE Id =: subjectPropertyId]; 
      system.debug('the property list is: '+propertyList); 

        Property__c subjectProperty; 
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
        //check and make sure proper status response 
        if(res.getStatusCode() == 200) {

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
          String status = PropertyUpdateFromZillow.parseStringAfter(('homeStatus: '+m.get('homeStatus'))); 
          updateMap.put('homeStatus',status); 
          String nonOwnerOccupied = PropertyUpdateFromZillow.parseStringAfter(('isNonOwnerOccupied: '+m.get('isNonOwnerOccupied'))); 
          updateMap.put('Owner_Occupied__c',nonOwnerOccupied); 
          String description = PropertyUpdateFromZillow.parseStringAfter(('description: '+m.get('description'))); 
          updateMap.put('description',description); 
          String propertyType = PropertyUpdateFromZillow.parseStringAfter(('homeType: '+m.get('homeType'))); 
          updateMap.put('PropertyType__c',propertyType);
          String taxId = PropertyUpdateFromZillow.parseStringAfter(('parcelNumber: '+m.get('parcelNumber'))); 
          updateMap.put('Tax_ID__c',taxId);
          String pic = PropertyUpdateFromZillow.parseStringAfter(('hiResImageLink: '+m.get('hiResImageLink'))); 
          updateMap.put('pic',pic);
          String latitude = PropertyUpdateFromZillow.parseStringAfter(('latitude: '+m.get('latitude'))); 
          updateMap.put('latitude',latitude);
          String longitude = PropertyUpdateFromZillow.parseStringAfter(('longitude: '+m.get('longitude'))); 
          updateMap.put('longitude',longitude);
          String valueEstimate = PropertyUpdateFromZillow.parseStringAfter(('zestimate: '+m.get('zestimate'))); 
          updateMap.put('valueEstimate',valueEstimate);

          List<Property__c> updateProperty = new List<Property__c>(); 

          subjectProperty.Baths__c = PropertyUpdateFromZillow.decimalNullCheck(updateMap.get('bathrooms')); 
          subjectProperty.Beds__c = PropertyUpdateFromZillow.decimalNullCheck(updateMap.get('bedrooms')); 
          subjectProperty.county__c = updateMap.get('county'); 
          subjectProperty.Last_Sale_Date__c = PropertyUpdateFromZillow.dateNullCheck(dateSoldString); 
          subjectProperty.Listing_Status__c = status; 
          subjectProperty.Non_Owner_Occupied__c = nonOwnerOccupied; 
          subjectProperty.Description__c = description; 
          subjectProperty.Property_Type__c = propertyType;
          if(taxId != null && taxId != 'null') {
            subjectProperty.Tax_ID__c = taxId; 
          }
          subjectProperty.Property_Picture_Link__c = pic; 
          subjectProperty.Latitude__c = PropertyUpdateFromZillow.decimalNullCheck(latitude); 
          subjectProperty.Longitude__c = PropertyUpdateFromZillow.decimalNullCheck(longitude); 
          subjectProperty.Value_Estimate__c = PropertyUpdateFromZillow.decimalNullCheck(valueEstimate); 

          updateProperty.add(subjectProperty); 
          update updateProperty; 

      }else{
        system.debug('There was a status error. '); 
      }
    }
  }
