trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    
    List<Task> newRelatedTasks = new List<Task>();
    
    for(Opportunity opp : Trigger.New) {
        if (opp.StageName.equals('Closed Won')) {
            newRelatedTasks.add(new Task(Subject='Follow Up Test Task', WhatId = opp.id ));
        }
    }
    
    if (newRelatedTasks.size() > 0) {
        insert newRelatedTasks;
    }
    
}