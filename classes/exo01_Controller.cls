public class exo01_Controller {
    // @auraEnabled to make the method visible to lightning actions (NEEDED)
    @auraEnabled
    public static List<Account> getAccounts() {

        /* All Accounts (LIMIT just in case) */
        // List<Account> accounts = [Select Id, Name FROM Account LIMIT 50];
        // return accounts;


        /* With associated Contacts' number */
        // List<Account> accounts = [SELECT Id, Name, (Select Id FROM Contacts) FROM Account ORDER BY Name];
        // return accounts;

        /* "My" Accounts only */
        // List<Account> accounts = [SELECT Id, Name FROM Account WHERE OwnerId = :UserInfo.getUserId() ORDER BY Name];
        // return accounts;



        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
        // For cleaner results in THIS exercice, only returns accounts that have at least one associated contact 
        List < Account > accounts =[SELECT Id, Name, (Select Id FROM Contacts) FROM Account ORDER BY Name LIMIT 1000];
        List < Account > prunedAccounts = new List<Account>();
        for (Account acc : accounts) {
            if ((acc.Contacts != null && acc.Contacts.size() > 0)) {
                prunedAccounts.add(acc);
            }
        }
        return prunedAccounts;
        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
        /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


    } 

    @auraEnabled
    public static List<Contact> getContactsByAccountId(Id accId) {
        return [SELECT Id, Firstname, Lastname, Birthdate FROM Contact WHERE accountId = : accId LIMIT 50];
    }

    @auraEnabled
    public static List<Account> getAccountsWithPagination(Integer pageIndex) { 
        System.debug('exo01_Controller - getPaginatedAccounts - pageIndex : START');

        if (Integer.valueOf(pageIndex) < 0) {
            pageIndex = 0;
        }
        System.debug('exo01_Controller - getPaginatedAccounts - pageIndex : ' + pageIndex);

        Integer nbRecordsPerPage = 10;
        Integer limiter = 11;
        Integer offset = Integer.valueOf(pageIndex) * Integer.valueOf(nbRecordsPerPage);

        System.debug('exo01_Controller - getPaginatedAccounts - offset : ' + offset);

        List <Account> accounts =[SELECT Id, Name, (Select Id, Birthdate FROM Contacts) FROM Account WHERE Id In (select AccountId from Contact) ORDER BY Name LIMIT :limiter OFFSET :offset];
        /* 
        List < Account > prunedAccounts = new List<Account>();
        for (Account acc : accounts) {
            if ((acc.Contacts != null && acc.Contacts.size() > 0)) {
                prunedAccounts.add(acc);
            }
        }
        accounts = prunnedAccounts;
         */
        System.debug('exo01_Controller - getPaginatedAccounts - accounts : ' + accounts);
        return accounts;
    }


}