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

        //integer null check 
        public static Integer integerNullCheck(Integer dec){
            if(dec==null) {
                return 0; 
            }else{
                return Integer.valueOf(dec); 
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

        //date ONLY null check 
        public static Date dateStrictNullCheck(Date dateString){
            if(dateString == null) {
                return null; 
            }else{
                return dateString; 
            }
        }

        //CURRENCY ONLY null check 
        public static Decimal currencyStrictNullCheck(Decimal feeString){
            if(feeString == null) {
                return 0.00; 
            }
            else if(String.valueOf(feeString) == 'null'){
                return 0.00;
            }
            else{
                return feeString; 
            }
        }

        //get status from api response 
        public static string getResponseMessage(Integer responseCode){
            String responseMessage; 
            if(responseCode == 200){
                responseMessage = '200: Response Successful at '+system.now(); 
            }
            if(responseCode == 400){
                responseMessage =  '400: Bad Request at '+system.now(); 
            }
            if(responseCode == 500){
                responseMessage =  '500: Internal Server Error at '+system.now()+'. Please try again later. '; 
            }

            if(responseCode == 503){
                responseMessage = '503: Service Unavailable at '+system.now()+'. Please try again later. '; 
            }
            return responseMessage; 
        }

        //get error message in successful response 
        public static Object getError(Map<String,Object> errorMap){
            Object errorResponse = errorMap.get('error'); 
            if(errorMap.get('error') != null){
                errorResponse = errorMap.get('error'); 
            }
            return errorResponse; 
        }

    }