public with sharing class ProcessHoasAndSubdivisions {
    
    public static Id matchSubdivisions(Property__c subjectProperty){
        List<Subdivision__c> subjectSubdivision = [SELECT Id, Name, Zip_Code_Text__c FROM Subdivision__c]; 
        List<Property__c> listForUpdate = new List<Property__c>(); 
        Id idForReturn; 
        for(Subdivision__c s: subjectSubdivision){
            if(subjectProperty.Vendor_Subdivision__c != null){
                if(subjectProperty.Zip_Code__c == s.Zip_Code_Text__c){
                    Boolean compareStrings = FuzzyMatching.checkMatch(s.Name, subjectProperty.Vendor_Subdivision__c); 
                    Boolean checkSubContains = s.Name.contains(subjectProperty.Vendor_Subdivision__c); 
                    system.debug('Sub Contains: '+checkSubContains); 
                    Boolean checkPropContains = subjectProperty.Vendor_Subdivision__c.contains(s.Name); 
                    system.debug('Prop Contains: '+checkPropContains); 
                    System.debug('Match: '+compareStrings); 
                    if(compareStrings == TRUE || checkSubContains==true || checkPropContains==true){
                        idForReturn = s.id; 
                    }
                }
            }
        }
        return idForReturn; 
    }
}
