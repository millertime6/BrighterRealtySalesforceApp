public with sharing class ProcessHoasAndSubdivisions {
    public static void matchSubdivisions(List<Property__c> subjectProperty){
        List<Subdivision__c> subjectSubdivision = [SELECT Id, Name FROM Subdivision__c]; 
        for(String s: subjectSubdivision){
            for(Subdivision__c sub: subjectProperty){
                if(sub.Vendor_Subdivision__c == null){
                    Integer maxDistance = FuzzyMatching.levenshteinDistance(s.Name,sub.Vendor_Subdivision__c); 
                    Boolean compareStrings = FuzzyMatching.applyFuzzyMatching(s.Name, sub.Vendor_Subdivision__c, maxDistance); 
                    if(compareStrings){
                        System.debug('the result is: '+compareStrings); 
                    }
                }
            }
        }
    }
}
