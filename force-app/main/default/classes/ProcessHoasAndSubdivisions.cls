public with sharing class ProcessHoasAndSubdivisions {
    
    public static Id matchSubdivisions(Property__c subjectProperty){
        List<Subdivision__c> subjectSubdivision = [SELECT Id, Name, Zip_Code_Text__c FROM Subdivision__c]; 
        List<Property__c> listForUpdate = new List<Property__c>(); 
        Id idForReturn; 
        Map<Id, Integer> thresholdMap = new Map<Id, Integer>(); 
        for(Subdivision__c s: subjectSubdivision){
                if(subjectProperty.Vendor_Subdivision__c != null){
                    if(subjectProperty.Zip_Code__c == s.Zip_Code_Text__c){
                        Boolean compareStrings = FuzzyMatching.checkMatch(s.Name, subjectProperty.Vendor_Subdivision__c); 
                        if(compareStrings == TRUE){
                        //need to move this to a separate method 
                        thresholdMap.put(s.id, FuzzyMatching.getLevenschteinValue(subjectProperty.Zip_Code__c, s.Zip_Code_Text__c)); 
                        }
                    }
                }
            }
        system.debug('threshold map: '+thresholdMap); 
        //get the smallest of the values that met the threshold requirement 
        Integer count = 0; 
        for(Id sub: thresholdMap.keySet()){
            if(thresholdMap.keySet() != null){
                if(count == 0){
                    idForReturn = sub; 
                }else{
                    if(thresholdMap.get(sub) < thresholdMap.get(idForReturn)){
                        idForReturn = sub; 
                    }
                }
            count +=1; 
        }
    }
        return idForReturn; 
    }
}