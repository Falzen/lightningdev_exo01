@isTest
public class AccountProcessorTest {
    @isTest
    public static void testCountContacts() {
        List<Id> actsId = new List<Id>();
        List<Contact> allContacts = new List<Contact>();
        
        Account acc1 = new Account(Name = 'account test 1');         
        insert acc1;
        actsId.add(acc1.Id);
        
        for (Integer i = 0; i < 10; i++) {
            Contact ct = new Contact(AccountId = acc1.Id, LastName = 'contact ' + i, FirstName = 'test ' + i);
            allContacts.add(ct);
        }
        insert allContacts;
        Test.startTest();
        	AccountProcessor.countContacts(actsId);
        Test.stopTest();
        
        Account gotAccount = [SELECT Id, Number_of_Contacts__c FROM Account LIMIT 1];
        Integer nbContact = (Integer) [select Count(id) qte from Contact where AccountId = :gotAccount.Id].get(0).get('qte');
        
        System.assertEquals(nbContact, gotAccount.Number_of_Contacts__c);    
        System.assertEquals(10, gotAccount.Number_of_Contacts__c);
        
        
    }
    
}