global with sharing class GetSaleAndMortgage {
    @future (callout=true)
    @auraEnabled
     Webservice static void getSaleAndMortgage(Id subjectPropertyId) {
      
      List<Sale_Mortgage__c> saleMortgageList = [SELECT Name, Id, First_Lender_Name__c, First_Mortgage_Balance__c,Second_Mortgage_Balance__c,Loan_Type__c, Mortgage_Recording_Date__c, 
                                        Owner_One_First_Name__c, Owner_One_Last_Name__c, Full_Property_Address__c, Owner_Two_First_Name__c, Owner_Two_Last_Name__c, Property__c, Recording_Date__c, Settle_Date__c, 
                                        Street_Address__c, City_and_State__c, City__c, Monthly_Taxes__c FROM Sale_Mortgage__c 
                                        WHERE Id =: subjectPropertyId]; 
        system.debug('the property list is: '+saleMortgageList); 

        Sale_Mortgage__c subjectSaleMortgage; 
        subjectSaleMortgage = saleMortgageList[0]; 
      
        //update url 
        String apiKey = '0ab956c73fcb4ffb82021c067bbafc8a'; 
        String propertyAddressToUpdate = subjectSaleMortgage.Full_Property_Address__c; 
        String paddedPropertyAddress = '/propertyapi/v1.0.0/property/expandedprofile?address1='+subjectSaleMortgage.Street_Address__c.replace(' ','%20').replace(',','').replace('Apt','')+'%2C'+subjectSaleMortgage.City__c.replace(' ','').replace('#','')+'&address2='+subjectSaleMortgage.City_and_State__c.replace(' ','%2C%20').replace(',',''); 
        // String paddedPropertyAddress = '/propertyapi/v1.0.0/property/expandedprofile?address1='+subjectSaleMortgage.Street_Address__c.replace(' ','%20').replace(',','')+'&address2='+subjectSaleMortgage.City_and_State__c.replace(' ','%2C%20').replace(',',''); 

        // Instantiate a new Http object
        Http h = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('apikey', apiKey); 
        req.setHeader('accept', 'application/json'); 

        // req.setHeader('X-RapidAPI-Host','https://api.gateway.attomdata.com'); 
        req.setEndpoint('callout:AttomApi'+paddedPropertyAddress);
        system.debug(paddedPropertyAddress);

    
        // Send the request, and return a response
        HttpResponse res = h.send(req);
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

            //4th level for owner names 
            Map<String, Object> owner1NameMap = (Map<String, Object>)ownerMap.get('owner1'); 
            Map<String, Object> owner2NameMap = (Map<String, Object>)ownerMap.get('owner2'); 
            Map<String, Object> taxMapValue = (Map<String, Object>)taxMap.get('taxAmt'); 

            //value assignments 
            subjectSaleMortgage.First_Mortgage_Balance__c = PropertyUpdateFromZillow.integerNullCheck(Integer.valueOf(firstConcurrent.get('amount'))); 
            subjectSaleMortgage.Second_Mortgage_Balance__c = Integer.valueOf(secondConcurrent.get('amount')); 
            subjectSaleMortgage.Loan_Type__c = String.valueOf(firstConcurrent.get('loanTypeCode')); 
            subjectSaleMortgage.Recording_Date__c = PropertyUpdateFromZillow.dateNullCheck(String.valueOf(firstConcurrent.get('date'))); 
            subjectSaleMortgage.Owner_One_First_Name__c = String.valueOf(owner1NameMap.get('firstNameAndMi')); 
            subjectSaleMortgage.Owner_One_Last_Name__c = String.valueOf(owner1NameMap.get('lastName')); 
            subjectSaleMortgage.Owner_Two_First_Name__c = String.valueOf(owner2NameMap.get('firstNameAndMi')); 
            subjectSaleMortgage.Owner_Two_Last_Name__c = String.valueOf(owner2NameMap.get('lastName')); 
            subjectSaleMortgage.Monthly_Taxes__c = Integer.valueOf(taxMapValue.get('taxAmt')); 

          //final updates
          List<Sale_Mortgage__c> updateSaleMortgage = new List<Sale_Mortgage__c>(); 
          updateSaleMortgage.add(subjectSaleMortgage); 
          update updateSaleMortgage; 

      }else{
        system.debug('There was a status error. '); 
      }
    }
}
