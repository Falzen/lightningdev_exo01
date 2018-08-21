@IsTest
public class exo01_Controller_Test {

    @testSetup static void setup() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i=0;i<20;i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;

        // create related test contacts
        Account accountTest = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 0'];
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<5;i++) {
            testContacts.add(new Contact(FirstName = 'Test Contact ' + i, LastName='Lastname test', AccountId = accountTest.Id));
        }
        insert testContacts;
    }

    @IsTest
    static void getAccounts_Test() {
        List<Account> accs = exo01_Controller.getAccounts();
        System.assert(accs.size() == 20);
        System.assertEquals('Test Account 0', accs[0].Name);
    }



    @IsTest
    static void getContactsByAccountId_Test() {
        Account accountTest = [SELECT Id, Name FROM Account WHERE Name = 'Test Account 0'];
        List<Contact> ctcs = exo01_Controller.getContactsByAccountId(accountTest.Id);
        System.assert(5 == ctcs.size());
        System.assertEquals(accountTest.Id, ctcs[0].AccountId);
        System.assertEquals('Test Contact 0', ctcs[0].FirstName);
    }


}