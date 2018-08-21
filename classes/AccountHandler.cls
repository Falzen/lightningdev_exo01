public class AccountHandler {
    
    public static Account insertNewAccount(String newName) {
    
        
        Account account = new Account(Name=newName);
        
        try {
            insert account;
       		return account;
        }catch(DmlException e) {
            System.debug('err message : ' + e.getMEssage());
        	return null;
        }
        
	
    }

}