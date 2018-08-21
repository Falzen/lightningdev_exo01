public class LC100_3C_PicklistField
{    
    // This method get all the picklist values and labels for the picklist given as parameter
	// and return it as a List<ValueWrapper> serialized in JSON
    @auraEnabled
	public static String getPicklistValues(String sObjectName, String fieldAPI)
    {
        
        System.debug('--- begin --- LC101_3C_PicklistField: - getPicklistValues() ---');
        System.debug('-- PARAM SOBJECTNAME: ' + sObjectName);
        System.debug('-- PARAM FIELDAPI: ' + fieldAPI);
        
        String serializedResult = '';                        
        List<ValueWrapper> result = new List<ValueWrapper>();
        
   
            Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
            Schema.SObjectType objType = objGlobal.get(sObjectName);
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();        
            
            Schema.DescribeFieldResult fieldResult = objDescribeFieldMap.get(fieldAPI).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for (Schema.PicklistEntry entry : ple) {
                if (entry.isActive())
                {
                    result.add(new ValueWrapper(entry.getLabel(), entry.getValue()));                    
                }
            }  

        serializedResult = JSON.serializePretty(result);
        System.debug('-- RESULT IS: ( ' + serializedResult + ')');
        System.debug('--- end --- LC101_3C_PicklistField: - getPicklistValues() ---');
        return serializedResult;
	}
    
    /* --------------------------------------------------------------------------------------------
    ** VALUE WRAPPER CLASS - object for picklist values 
    ** ----------------------------------------------------------------------------------------- */   
    
    public class ValueWrapper {
        public String label;
        public String value;
        
        public ValueWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }    
}