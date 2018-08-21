public class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer nb, String lastName) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0; i<nb; i++) {
            contacts.add(new Contact(FirstName='test '+i, LastName=lastName));
        }
        return contacts;
    }
    
    
}