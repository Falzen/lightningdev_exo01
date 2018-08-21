public class DailyLeadProcessor implements Schedulable {
    
    public void execute(SchedulableContext sctx) {
        List<Lead> leads = [SELECT LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];
        if(leads.size() != 0) {            
            for(Lead l : leads) {
                l.LeadSource = 'Dreamforce';
            }
            update leads;            
        }
        
    }
}