public with sharing class FuzzyMatching {
    
    //calculate threshold 
    public static Integer calculateThreshold(String str1, String str2){
        Integer str1Length = str1.length(); 
        Integer str2Length = str2.length(); 
        Integer thresholdValue; 
        Decimal thresholdPercent; 
        if(str1.contains(str2) || str2.contains(str1)){
            thresholdPercent = .75; 
        }else{
            thresholdPercent = .25; 
        }
        Integer averageStrLength = (str1Length + str2Length)/2; 
        return Math.round(averageStrLength * thresholdPercent);  
    }

    //calculate levenschtein distance
    public static Integer getLevenschteinValue(String str1, String str2){
    List<Integer> levList = new List<Integer>(); 
        return str1.getLevenshteinDistance(str2); 
    }
    
    public static Boolean checkMatch(String str1, String str2) {

        // Calculate the distance between the two strings
        Integer distance = str1.getLevenshteinDistance(str2);
        system.debug('Levenschtein Distance: '+distance); 
        system.debug('String 1: '+str1+', String 2: '+str2); 

        // Set the maximum allowed distance between the strings
        Integer threshold = Math.round(calculateThreshold(str1, str2));
        system.debug('String 1: '+str1+', String 2: '+str2); 
        system.debug('Threshold: '+threshold); 

        // If the distance is less than or equal to the threshold, return true
        // Otherwise, return false
        return distance <= threshold;
        }
        
    }

    //to calculate threshold value 
    //use ratio of str lengths to assign higher threshold to most similar string lengths  
    //multiply ratio by distance to get threshold 