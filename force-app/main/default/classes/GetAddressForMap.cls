public with sharing class GetAddressForMap {
    @auraEnabled
    public static List<Property__c> getAddressForApexMap(String propertyId) {
        List<Property__c> subjectPropertyForMap = [SELECT Id, Name, Latitude__c, Longitude__c FROM Property__c WHERE Id =: propertyId]; 
            // if(subjectPropertyForMap[0].Latitude__c != NULL && subjectPropertyForMap[0].Longitude__c != NULL){
                List<String> coordinates = new List<String>(); 
                String propertyLatitude = String.valueOf(subjectPropertyForMap[0].Latitude__c); 
                System.debug('Latitude: '+propertyLatitude); 
                String propertyLongitude = String.valueOf(subjectPropertyForMap[0].Longitude__c); 
                System.debug('Longitude: '+propertyLongitude); 
                coordinates.add(propertyLatitude); 
                coordinates.add(propertyLongitude); 
                System.debug('Coordinates: '+coordinates); 
                return subjectPropertyForMap; 

            // }

    }
}
