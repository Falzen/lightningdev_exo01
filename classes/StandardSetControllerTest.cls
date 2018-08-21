@isTest 
private class StandardSetControllerTest{
    static testMethod void testAllMethods() {
    	String result = StandardSetController.getFilters('Account');
		for( String filterId:StandardSetController.getFiltersSimple('Account') ){
			StandardSetController.getRecords( 'Account', 'Id,Name', filterId,1, 5);
		}
	}
}