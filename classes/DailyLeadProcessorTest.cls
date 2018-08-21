@isTest
public class DailyLeadProcessorTest {
        // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest
    public static void correctLeadsourceUpdating() {
        
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead();
            l.LastName = 'LastName' + i;
            l.Company = 'Company';
            
            leads.add(l);
        }
        insert leads;
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('DailyLeadProcessorTest',
                                       CRON_EXP, 
                                       new DailyLeadProcessor());
        
        Test.stopTest();
        
        List<Lead> updatedLeads = [SELECT LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        
        System.assertEquals(200, updatedLeads.size());
        
    }
    
    
    
    
    
}