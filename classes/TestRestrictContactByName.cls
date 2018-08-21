@isTest
public class TestRestrictContactByName {
	
    @isTest
    static void TestContactNameRestrict() {
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName='Test Contact'));
        contacts.add(new Contact(LastName='INVALIDNAME'));
        Test.startTest();
        	Database.SaveResult[] insertedContacts = Database.insert(contacts, false);
        Test.stopTest();
        
        for (Database.SaveResult sr : insertedContacts) {
            if (sr.isSuccess()) {
                
            }
            else {
                
            }
        }
        
        
    }
        
        
       
    
    
}