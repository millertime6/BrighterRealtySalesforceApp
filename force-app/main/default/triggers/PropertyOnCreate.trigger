trigger PropertyOnCreate on Property__c (before update, after insert, after update) {
   
    SWITCH ON Trigger.operationType{
         WHEN AFTER_INSERT{
            Id updateProperty; 
            for(Property__c p : Trigger.new) {
                GetPropertyListing.getPropertyListingData(p.Id);    
             } 
         }   

         WHEN BEFORE_UPDATE{
            Id updateProperty; 
            for(Property__c p : Trigger.new) {
                if(p.Subdivision__c == null){
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                }
            }
        }
        WHEN BEFORE_INSERT{
            Id updateProperty; 
            for(Property__c p : Trigger.new) {
                if(p.Subdivision__c == null){
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                }
            }
        }
     }
 }