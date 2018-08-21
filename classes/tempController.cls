public class tempController {

    @auraEnabled
    public static List<Account> getAccounts() {
        return [SELECT name, LightningStars__Stock_symbol__c FROM Account WHERE LightningStars__Stock_symbol__c != null];
        // return [SELECT name, LightningStars__Stock_symbol__c FROM Account WHERE LightningStars__Stock_symbol__c != null];
    }
}