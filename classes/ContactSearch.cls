public class ContactSearch {
    public static List<Contact> searchForContacts(String lastname, String mailingPostCode) {
        List<Contact> contactsFound;
        
        contactsFound = [SELECT Id, Name FROM Contact
                   WHERE (LastName = :lastname AND MailingPostalCode = :mailingPostCode)];

        system.debug(contactsFound);
        return contactsFound;
    }
}