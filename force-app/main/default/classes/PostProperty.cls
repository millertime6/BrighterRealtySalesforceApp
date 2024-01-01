@RestResource(urlMapping='/Property__c')
global with sharing class PostProperty {
    @HttpPost
    global static void createProperty() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        //grab the property info from the json body
        String jsonBody = request.requestBody.toString();
        system.debug('jsonBody: ' + jsonBody);
        Map<String, Object> myMap = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
        system.debug('myMap: ' + myMap);
        //send the response back to the caller
        response.responseBody = Blob.valueOf('{"status": "success"}');
        response.statusCode = 200;
        String address = myMap.get('Property_Address__c').toString();
        String city = myMap.get('City__c').toString();
        String zip = myMap.get('Zip__c').toString();
        String name = address; 
        system.debug('name: ' + name+ ', address: ' + address+ ', city: '+city+ ', zip: ' + zip);
        // parse the json body and create a property record
        Property__c newProperty = new Property__c(
            Name = name,
            Property_Address__City__s = city,
            Property_Address__Street__s = address,
            Property_Address__PostalCode__s = zip
        );
        system.debug('newProperty: ' + newProperty);
        try {
            insert newProperty;
        } catch (Exception e) {
            system.debug('error: ' + e.getMessage());
        }
        
    }
   
    
    
}