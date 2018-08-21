@isTest
public class AddPrimaryContactTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i=0; i<50; i++) {
            accounts.add(new Account(Name='testNy', BillingState='NY'));
            accounts.add(new Account(Name='testCa', BillingState='CA'));
        }
        
        insert accounts;
    }
    
    
    static testmethod void testQueueable() {
        
        AddPrimaryContact apc = new AddPrimaryContact(new Contact(FirstName='firstnameTest', LastName='lastNameTest'), 'CA');
        
        Test.startTest();
        System.enqueueJob(apc);
        Test.stopTest();
        
        System.assertEquals(50, [SELECT count() FROM Account WHERE BillingState='CA']);
    }
}