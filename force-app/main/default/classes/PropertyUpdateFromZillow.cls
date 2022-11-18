global with sharing class PropertyUpdateFromZillow {

        public static String parseStringAfter(String str){
            return str.substringAfter(': '); 
        }

        //parse string value method 
        public static String stringOnlyNullCheck(String str){
            if(String.isBlank(str)) {
                return null; 
            }
            if(str == 'null'){
                return null; 
            }else{
                return String.valueOf(str); 
            }
        }


        //decimal null check 
        public static Decimal decimalNullCheck(String dec){
            if(String.isBlank(dec)) {
                return 0.00; 
            }
            if(dec == 'null') {
                return 0.00; 
            }else{
                return decimal.valueOf(dec); 
            }
        }

        //string  null check 
        public static Date stringNullCheck(String str){
            if(String.isBlank(str)) {
                return null; 
            }
            if(str == 'null'){
                return null; 
            }else{
                return Date.valueOf(str); 
            }
        }

        //date null check 
        public static Date dateNullCheck(String dateString){
            if(String.isBlank(dateString)) {
                return null; 
            }
            if(dateString == 'null'){
                return null; 
            }else{
                return Date.valueOf(dateString); 
            }
        }
    }
