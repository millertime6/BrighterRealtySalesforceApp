public class ThrowCustomErrors{
        public class CustomException extends Exception{}
    
    @InvocableMethod(label='Throw Custom Flow Exception')
        public static void invocablePropertyOwnerException(){
        String e = 'You need to have at least one of the first owner names filled in.';
        throw createCustomException(e); 
    }
    
    static CustomException createCustomException(String message) {
        CustomException ex = new CustomException(message);
        ex.setMessage(message);
        return ex;
    }
    
  }