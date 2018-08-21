public class NewCaseListController {
	
    public List<Case> getNewCases() {
        List<Case> cases = new List<Case>();
        cases = [SELECT Id, Description, CaseNumber FROM Case WHERE Status = 'New'];
        
        
        return cases;
    }
}