trigger PropertyDuplicateCheck on Property__c (before insert) {
    Map<String, Property__c> properties = new Map<String, Property__c>();
    for(Property__c p : [SELECT Name, Id, owner.FirstName, owner.LastName FROM Property__c]){
        properties.put(p.Name, p);
    }
    system.debug(properties); 
        for(Property__c p : Trigger.new){
            if(properties.size() != null){ 
                if(p.Name == properties.get(p.Name).Name){
                    p.addError('Property already exists with the name ' + p.Name+ ' and owner ' + p.owner.FirstName + ' ' + p.owner.LastName);
                }
            }
        }
    }