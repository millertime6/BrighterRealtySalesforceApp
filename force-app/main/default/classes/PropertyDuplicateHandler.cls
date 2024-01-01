public with sharing class PropertyDuplicateHandler {
    public static Boolean checkForPropertyDupes() {
        List<Property__c> properties = [SELECT Id, Name FROM Property__c];
         return true;
    }
}