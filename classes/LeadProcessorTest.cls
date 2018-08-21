@isTest
public class LeadProcessorTest {
    
    @isTest
    public static void updatingLeads() {
        // create and insert test data
        List<Lead> newLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            newLeads.add(new Lead(LastName='lastname test', Company='company test'));
        }
        insert newLeads;
        
        // call the method to be tested
        Test.startTest();        
            LeadProcessor ld = new LeadProcessor();        
            Id batchId = Database.executeBatch(ld);        
        Test.stopTest();
        
        
        // go get the data back and test it
        List<Lead> leadsFromDb = [SELECT LeadSource FROM Lead];
        System.debug(leadsFromDb);
        
        for (Lead l : leadsFromDb) {
        	System.assertEquals('Dreamforce', l.LeadSource);
        }
    }
    
}