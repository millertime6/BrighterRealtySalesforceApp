public with sharing class FuzzyMatching {
    public static Boolean checkMatch(String str1, String str2) {

        // Calculate the distance between the two strings
        Integer distance = str1.getLevenshteinDistance(str2);
        system.debug('Levenschtein Distance: '+distance); 
        system.debug('String 1: '+str1+', String 2: '+str2); 

        // Set the maximum allowed distance between the strings
        Integer threshold = 4;

        // If the distance is less than or equal to the threshold, return true
        // Otherwise, return false
        return distance <= threshold;
        }
        
    }