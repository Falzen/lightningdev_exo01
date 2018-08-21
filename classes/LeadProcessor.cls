global class LeadProcessor implements Database.Batchable<sObject> {

    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Id, LeadSource FROM Lead'
        );
    }

    global void execute(Database.BatchableContext bc, List<Lead> records){
        // process each batch of records
        List<Lead> leads = new List<Lead>();
        for (Lead l : records) {
            l.LeadSource = 'Dreamforce';
            leads.add(l);
            recordsProcessed++;
        }
        update leads;
    }    

    global void finish(Database.BatchableContext bc){
        System.Debug('record processed : ' + recordsProcessed);
    }   
    
}