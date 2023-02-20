trigger PropertyOnCreate on Property__c (before update, after insert, after update) {
   
    SWITCH ON Trigger.operationType{
         WHEN AFTER_INSERT{
            for(Property__c p : Trigger.new) {
                GetPropertyListing.getPropertyListingData(p.Id);  
                GetSaleAndMortgage.getSaleAndMortgage(p.Id);
                system.debug('Property Created: ' + p.Id);
             } 
         }   

         WHEN BEFORE_UPDATE{
            for(Property__c p : Trigger.new) {
                if(p.Subdivision__c == null){
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                }
            }
        }
        WHEN BEFORE_INSERT{
            for(Property__c p : Trigger.new) {
                if(p.Subdivision__c == null){
                p.Subdivision__c = ProcessHoasAndSubdivisions.matchSubdivisions(p); 
                }
            }
        }
     }
 }