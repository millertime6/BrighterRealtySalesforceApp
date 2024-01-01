public with sharing class GetWorkOrders {
    @auraEnabled(cacheable=true)
    public static List <Work_Order__c> getWorkOrders(Id projectId) {
        List<Work_Order__c> openWorkOrders = new List<Work_Order__c>(); 
            for(Work_Order__c wo: [SELECT Id, Due_Date__c, Project__c, Status__c, Vendor__c, Name FROM Work_Order__c WHERE Project__c =: projectId]){
                openWorkOrders.add(wo); 
        }
        return openWorkOrders; 
    }
}