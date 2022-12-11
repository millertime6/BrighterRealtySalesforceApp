public with sharing class GetAddressForMap {
    @auraEnabled
    public static List<String> GetAddressForApexMap(String propertyId) {
        List<String> coordinates = new List<String>(); 
        List<Property__c> subjectPropertyForMap = [SELECT Id, Name, Latitude__c, Longitude__c FROM Property__c WHERE Id =: propertyId LIMIT 1]; 
            if(subjectPropertyForMap[0].Latitude__c != NULL && subjectPropertyForMap[0].Longitude__c != NULL){
                String propertyLatitude = String.valueOf(subjectPropertyForMap[0].Latitude__c); 
                String propertyLongitude = String.valueOf(subjectPropertyForMap[0].Longitude__c); 
                coordinates.add(propertyLatitude); 
                coordinates.add(propertyLongitude); 
            }
            return coordinates; 

    }
}
