public with sharing class FuzzyMatching {
    public Integer levenshteinDistance (String lhs, String rhs) {                          
        Integer len0 = lhs.length() + 1;                                                     
        Integer len1 = rhs.length() + 1;                                                     
                                                                                        
        // the array of distances                                                       
        Integer[] cost = new Integer[len0];                                                     
        Integer[] newcost = new Integer[len0];                                                  
                                                                                        
        // initial cost of skipping prefix in String s0                                 
        for (Integer i = 0; i < len0; i++) cost[i] = i;                                     
                                                                                        
        // dynamically computing the array of distances                                  
                                                                                        
        // transformation cost for each letter in s1                                    
        for (Integer j = 1; j < len1; j++) {                                                
            // initial cost of skipping prefix in String s1                             
            newcost[0] = j;                                                             
                                                                                        
            // transformation cost for each letter in s0                                
            for(Integer i = 1; i < len0; i++) {                                             
                // matching current letters in both strings                             
                Integer match = (lhs.charAt(i - 1) == rhs.charAt(j - 1)) ? 0 : 1;             
                                                                                        
                // computing cost for each transformation                               
                Integer cost_replace = cost[i - 1] + match;                                 
                Integer cost_insert  = cost[i] + 1;                                         
                Integer cost_delete  = newcost[i - 1] + 1;                                  
                                                                                        
                // keep minimum cost                                                    
                newcost[i] = Math.min(Math.min(cost_insert, cost_delete), cost_replace);
            }                                                                           
                                                                                        
            // swap cost/newcost arrays                                                 
            Integer[] swap = cost; cost = newcost; newcost = swap;                          
        }                                                                               
                                                                                        
        // the distance is the cost for transforming all letters in both strings        
        return cost[len0 - 1];                                                          
    }

    public static boolean applyFuzzyMatching(String s1, String s2, Integer maxDistance) {
        Integer m = s1.length();
        Integer n = s2.length();
        List <List<Integer>> d = new List<List<Integer>>[m + 1][n + 1];
        
        for (Integer i = 0; i <= m; i++) {
            d[i][0] = i;
        }
        
        for (Integer j = 0; j <= n; j++) {
            d[0][j] = j;
        }
        
        for (Integer j = 1; j <= n; j++) {
            for (Integer i = 1; i <= m; i++) {
                Integer cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;
                d[i][j] = Math.min(Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1), d[i - 1][j - 1] + cost);
            }
        }
        
        return d[m][n] <= maxDistance;
    }
    
}
