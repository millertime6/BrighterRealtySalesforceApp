trigger PropertyOnCreate on Property__c (after insert, after update) {
   
    SWITCH ON Trigger.operationType{
         WHEN AFTER_INSERT{
         for(Property__c p : Trigger.new) {
             GetPropertyListing.getPropertyListingData(p.Id);
             }
         }   
     }
 }