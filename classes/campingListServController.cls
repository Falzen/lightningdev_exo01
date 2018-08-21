public with sharing class campingListServController {
    
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {
        return [SELECT Id, Name, Quantity__c, Price__c, Packed__c FROM Camping_Item__c];
    }
        
}