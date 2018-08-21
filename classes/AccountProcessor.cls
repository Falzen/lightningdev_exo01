public class AccountProcessor {
	@future	
    public static void countContacts(List<Id> accountIds) {
      List<Account> listAccount = [select id,Number_of_Contacts__c , (select id from Contacts) from Account where id in :accountIds ];
      for( Account currentAccount : listAccount ) {
          currentAccount.Number_of_Contacts__c = currentAccount.contacts.size();         
      }
      update listAccount;
  }
}