public class AddPrimaryContact implements Queueable {
    
    private Contact contact;
    private String strState;
    
    public AddPrimaryContact (Contact contact, String strState) {
        this.contact = contact;
        this.strState = strstate;
    }
    
    public void execute(QueueableContext context) {
        
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :this.strState LIMIT 200];
        
        for (Account account : accounts) {
            contact.clone(false, false, false, false).Account = account;
        }
        update accounts;
    }
    
}