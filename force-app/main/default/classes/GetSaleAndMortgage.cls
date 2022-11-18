global with sharing class GetSaleAndMortgage {
    @auraEnabled
     Webservice static void getSaleAndMortgage(Id subjectPropertyId) {
      
      List<Sale_Mortgage__c> saleMortgageList = [SELECT Name, Id, First_Lender_Name__c, First_Mortgage_Balance__c,Second_Mortgage_Balance__c,Loan_Type__c, Mortgage_Recording_Date__c, 
                                        Owner_One_First_Name__c, Owner_One_Last_Name__c, Full_Property_Address__c, Owner_Two_First_Name__c, Owner_Two_Last_Name__c, Property__c, Recording_Date__c, Settle_Date__c, 
                                        Street_Address__c, City_and_State__c FROM Sale_Mortgage__c 
                                        WHERE Property__c =: subjectPropertyId]; 
        system.debug('the property list is: '+saleMortgageList); 

        Sale_Mortgage__c subjectSaleMortgage; 
        subjectSaleMortgage = saleMortgageList[0]; 
      
        //update url 
        String apiKey = '0ab956c73fcb4ffb82021c067bbafc8a'; 
        String propertyAddressToUpdate = subjectSaleMortgage.Full_Property_Address__c; 
        String paddedPropertyAddress = '/propertyapi/v1.0.0/property/expandedprofile?address1='+subjectSaleMortgage.Street_Address__c.replace(' ','%20').replace(',','')+'&address2='+subjectSaleMortgage.City_and_State__c.replace(' ','%2C%20').replace(',',''); 
        //https://api.gateway.attomdata.com/propertyapi/v1.0.0/property/expandedprofile?address1=4756%20Witchhazel%20Way&address2=Aberdeen%2C%20MD

    
        // Instantiate a new Http object
        Http h = new Http();
    
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('apikey', apiKey); 
        req.setHeader('accept', 'application/json'); 

        // req.setHeader('X-RapidAPI-Host','https://api.gateway.attomdata.com'); 
        req.setEndpoint('callout:AttomApi'+paddedPropertyAddress);
    
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        //check and make sure proper status response 
        if(res.getStatusCode() == 200) {

          Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
          //create separate class to hold mapped values 
          //create instance of the class here 
          //update instance values with mapped results from callout response 
          Map<String,Object> rMap = new Map<String,Object>();
          Map<String,Object> area = new Map<String,Object>(); 
          Map<String,Object> address = new Map<String,Object>(); 
          Map<String,Object> assessment = new Map<String,Object>(); 
          Map<String,Object> mortgage = new Map<String,Object>(); 
          Map<String,Object> sale = new Map<String,Object>(); 
          Map<String,Object> building = new Map<String,Object>(); 
          Map<String,Object> lot = new Map<String,Object>(); 

            //1st level of nesting
            List<Object> property = (List<Object>) m.get('property'); //get the records
            if (property != null) {
                for (Object r : property) {
                    rMap = (Map<String,Object>)r;
                    lot = (Map<String,Object>)rMap.get('lot');
                    area = (Map<String,Object>)rMap.get('area');
                    address = (Map<String,Object>)rMap.get('address');
                    assessment = (Map<String,Object>)rMap.get('assessment');
                    building = (Map<String,Object>)rMap.get('building');

                    System.debug(property);
                }
            } else {
                system.debug('null.. : ' + property);
            }

          //2nd level of nesting for lot
          Map<String,Object> lMap = new Map<String,Object>();
          Map<String,Object> lotNum = new Map<String,Object>(); 
          Map<String,Object> lotSize1 = new Map<String,Object>(); 
          Map<String,Object> lotSize2 = new Map<String,Object>(); 
          Map<String,Object> zoningType = new Map<String,Object>(); 
          Map<String,Object> siteZoningIdent = new Map<String,Object>(); 
          List<Object> subLot = (List<Object>) rMap.get('lot'); //get the records
            if (subLot != null) {
                for (Object l : subLot) {
                    lMap = (Map<String,Object>)l;
                    lotNum = (Map<String,Object>)lMap.get('lotNum');
                    lotSize1 = (Map<String,Object>)lMap.get('lotSize1');
                    lotSize2 = (Map<String,Object>)lMap.get('lotSize2');
                    zoningType = (Map<String,Object>)lMap.get('zoningType');
                    siteZoningIdent = (Map<String,Object>)lMap.get('siteZoningIdent');

                    System.debug('lot: '+subLot);
                    System.debug('lotNum: '+subLot[0]); 
                }
            } else {
                system.debug('null.. : ' + subLot);
            }

          //3rd level of nesting 


          //4th level of nesting

          
          
          //final updates
          List<Sale_Mortgage__c> updateSaleMortgage = new List<Sale_Mortgage__c>(); 
          updateSaleMortgage.add(subjectSaleMortgage); 
          update updateSaleMortgage; 

      }else{
        system.debug('There was a status error. '); 
      }
    }
}
