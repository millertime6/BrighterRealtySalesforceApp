trigger PropertyOnCreate on Property__c (before update, after insert, after update) {
   
    SWITCH ON Trigger.operationType{
         WHEN AFTER_INSERT{
            Id updateProperty; 
            List<Property__c> prop = new List<Property__c>();
            for(Property__c p : Trigger.new) {
                GetPropertyListing.getPropertyListingData(p.Id);    
             } 
         }   

         WHEN BEFORE_UPDATE{
            Id updateProperty; 
            List<Property__c> prop = new List<Property__c>();
            for(Property__c p : Trigger.new) {
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                prop.add(p); 
            }
        }
        WHEN BEFORE_INSERT{
            Id updateProperty; 
            List<Property__c> prop = new List<Property__c>();
            for(Property__c p : Trigger.new) {
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                prop.add(p); 
            }
        }
     }
 }