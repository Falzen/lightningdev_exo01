public class myContactListController {
    
    @AuraEnabled
    public static List<Contact> getContacts() {
        return [Select Id, Name, Email, Title, Phone From Contact];
    }
    
}