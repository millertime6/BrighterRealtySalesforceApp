global with sharing class GetSaleAndMortgage {
    @future (callout=true)
    @auraEnabled
     Webservice static void getSaleAndMortgage(Id subjectPropertyId) {
      
      List<Sale_Mortgage__c> saleMortgageList = [SELECT Name, Id, First_Lender_Name__c, First_Mortgage_Balance__c,Second_Mortgage_Balance__c,Loan_Type__c, Mortgage_Recording_Date__c, 
                                        Owner_One_First_Name__c, Owner_One_Last_Name__c, Full_Property_Address__c, Owner_Two_First_Name__c, Owner_Two_Last_Name__c, Property__c, Recording_Date__c, Settle_Date__c, 
                                        Street_Address__c, City_and_State__c, City__c, Monthly_Taxes__c, Attom_ID__c, Vendor_Subdivision__c FROM Sale_Mortgage__c 
                                        WHERE Id =: subjectPropertyId]; 
        system.debug('the property list is: '+saleMortgageList); 

        //get the subject property
        Property__c subjectProperty = [SELECT Id, Name, Full_Address__c, Vendor_Subdivision__c FROM Property__c WHERE Id =: subjectPropertyId];

        Sale_Mortgage__c subjectSaleMortgage; 
        if(saleMortgageList.size() > 0){
          subjectSaleMortgage = saleMortgageList[0]; 
        }
      
        //update url 
        String apiKey = '24171d6fa3f6247bb1dff49522af1566'; 
        String propertyAddressToUpdate; 
        if(subjectSaleMortgage != null && subjectProperty != null){
          propertyAddressToUpdate = subjectProperty.Full_Address__c;
        }
        String paddedPropertyAddress = '/propertyapi/v1.0.0/property/expandedprofile?address1='+subjectSaleMortgage.Street_Address__c.replace(' ','%20').replace(',','').replace('Apt','').replace('#','')+'%2C'+subjectSaleMortgage.City__c.replace(' ','')+'&address2='+subjectSaleMortgage.City_and_State__c.replace(' ','%2C%20').replace(',',''); 
        // String paddedPropertyAddress = '/propertyapi/v1.0.0/property/expandedprofile?address1='+subjectSaleMortgage.Street_Address__c.replace(' ','%20').replace(',','')+'&address2='+subjectSaleMortgage.City_and_State__c.replace(' ','%2C%20').replace(',',''); 

        // Instantiate a new Http object
        Http h = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('apikey', apiKey); 
        req.setHeader('accept', 'application/json'); 
        String fullErrorMessage; 

        // req.setHeader('X-RapidAPI-Host','https://api.gateway.attomdata.com'); 
        req.setEndpoint('callout:AttomApi'+paddedPropertyAddress);
        system.debug(paddedPropertyAddress);

    
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        List<Sale_Mortgage__c> updateSaleMortgage = new List<Sale_Mortgage__c>(); 

        //check and make sure proper status response 
        if(res.getStatusCode() == 200) {

          Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
          system.debug('full response: '+m); 
          
          //create separate class to hold mapped values 
          //update instance values with mapped results from callout response 
          //make map of the highest level items and query within them with get methods 
          Map<String,Object> rMap = new Map<String,Object>();
          Map<String,Object> lot = new Map<String,Object>(); 
          Map<String,Object> area = new Map<String,Object>(); 
          Map<String,Object> summary = new Map<String,Object>(); 
          Map<String,Object> sale = new Map<String,Object>(); 
          Map<String,Object> assessment = new Map<String,Object>(); 
          Map<String,Object> identifier = new Map<String,Object>(); 


            //1st level of nesting - add main object to list and get main subject objects into a map
            List<Object> property = (List<Object>) m.get('property'); //get the records
            if (property != null) {
                for (Object r : property) {
                    rMap = (Map<String,Object>)r;
                    lot = (Map<String,Object>)rMap.get('lot');
                    area = (Map<String,Object>)rMap.get('area');
                    summary = (Map<String,Object>)rMap.get('summary');
                    sale = (Map<String,Object>)rMap.get('sale');
                    assessment = (Map<String,Object>)rMap.get('assessment');
                    identifier = (Map<String,Object>)rMap.get('identifier');

                }
            } else {
                system.debug('null.. : ' + property);
            }
            //testing 
            system.debug('assessment: '+assessment); 
            system.debug(assessment.get('mortgage')); 

            //2nd level 
            //need to extract mortgage and owner from assessment
            Map<String,Object> mortgageMap = (Map<String, Object>) assessment.get('mortgage'); 
            Map<String,Object> ownerMap = (Map<String, Object>) assessment.get('owner'); 
            Map<String,Object> taxMap = (Map<String, Object>) assessment.get('tax'); 

            //3rd level 
            //need to extract FirstConcurrent and SecondConcurrent from Mortgage  
            //adding FirstConcurrent and SecondConcurrent to maps for content retrieval 
            Map<String, Object> firstConcurrent = (Map<String, Object>)mortgageMap.get('FirstConcurrent'); 
            Map<String, Object> secondConcurrent = (Map<String, Object>)mortgageMap.get('SecondConcurrent'); 
            // Map<String, Object> taxMapValue = (Map<String, Object>)taxMap.get('taxAmt'); 

            //4th level for owner names 
            Map<String, Object> owner1NameMap = (Map<String, Object>)ownerMap.get('owner1'); 
            Map<String, Object> owner2NameMap = (Map<String, Object>)ownerMap.get('owner2'); 

            //value assignments 
            subjectSaleMortgage.First_Mortgage_Balance__c = PropertyUpdateFromZillow.integerNullCheck(Integer.valueOf(firstConcurrent.get('amount'))); 
            subjectSaleMortgage.Second_Mortgage_Balance__c = Integer.valueOf(secondConcurrent.get('amount')); 
            subjectSaleMortgage.Loan_Type__c = String.valueOf(firstConcurrent.get('loanTypeCode')); 
            subjectSaleMortgage.Recording_Date__c = PropertyUpdateFromZillow.dateNullCheck(String.valueOf(firstConcurrent.get('date'))); 
            subjectSaleMortgage.Owner_One_First_Name__c = String.valueOf(owner1NameMap.get('firstNameAndMi')); 
            subjectSaleMortgage.Owner_One_Last_Name__c = String.valueOf(owner1NameMap.get('lastName')); 
            subjectSaleMortgage.Owner_Two_First_Name__c = String.valueOf(owner2NameMap.get('firstNameAndMi')); 
            subjectSaleMortgage.Owner_Two_Last_Name__c = String.valueOf(owner2NameMap.get('lastName')); 
            subjectSaleMortgage.Owner_Two_Last_Name__c = String.valueOf(owner2NameMap.get('lastName')); 
            subjectSaleMortgage.Attom_ID__c = String.valueOf(identifier.get('attomId')); 
            subjectSaleMortgage.Vendor_Subdivision__c = String.valueOf(area.get('subdName'));
            subjectSaleMortgage.Response_Message__c = PropertyUpdateFromZillow.getResponseMessage(res.getStatusCode())+', error code= '+PropertyUpdateFromZillow.getError(m); 
            subjectSaleMortgage.Property__c = subjectPropertyId;

            if(String.valueOf(taxMap.get('taxAmt')) != null){
              subjectSaleMortgage.Monthly_Taxes__c = Integer.valueOf(taxMap.get('taxAmt'))/12; 
            }

          system.debug('Attom ID: '+string.valueOf(identifier.get('attomId'))); 
          //final updates
          updateSaleMortgage.add(subjectSaleMortgage); 
          update updateSaleMortgage; 

      }else{
        system.debug('There was a status error. '); 
        subjectSaleMortgage.Response_Message__c = 'There was a status error: '+PropertyUpdateFromZillow.getResponseMessage(res.getStatusCode()); 
        updateSaleMortgage.add(subjectSaleMortgage); 
        update updateSaleMortgage; 
      }
    }
}