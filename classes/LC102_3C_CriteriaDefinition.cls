global class LC102_3C_CriteriaDefinition
{ 

    /* --------------------------------------------------------------------------------------------
    ** This method gets all the fields APIName and labels the sObject given as parameter
    ** and return it as a List<ValueWrapper> serialized in JSON
    ** ----------------------------------------------------------------------------------------- */  
    @AuraEnabled
    public static String getObjectFields(String sObjectName, String listName)
    {
        String serializedResults = '';
        List<FieldValueWrapper> results = new List<FieldValueWrapper>();
        List<CS102_3C_CriteriaDefinitionFields__c> allowedFieldsFromCs = new List<CS102_3C_CriteriaDefinitionFields__c>();
        
        // if listName is not null, find the criterion setting
        if (listName != '')
        {
            // get profil user
            String userLike = '%'+UserInfo.getName()+'%';
            String profileLike = '%' + [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()][0].Name + '%';

            allowedFieldsFromCs = [SELECT Name, listName__c, sObjectName__c, fieldName__c
                                   FROM CS102_3C_CriteriaDefinitionFields__c
                                   WHERE ListName__c = :listName AND sObjectName__c = :sObjectName AND (profiles__c LIKE :profileLike OR users__c LIKE :userLike)];
        }
        
        // get Map to Fields SObject (Name, LastName)
        Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
        Schema.SObjectType objType = objGlobal.get(sObjectName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();                
        
        // If we have results, then those values prevails on the default picklist values
        if (allowedFieldsFromCs != null && allowedFieldsFromCs.size() > 0)
        {            
            for (CS102_3C_CriteriaDefinitionFields__c allowedFieldFromCs : allowedFieldsFromCs)   
            {
                if(objDescribeFieldMap.get(allowedFieldFromCs.fieldName__c) != null){
                    Schema.DescribeFieldResult temp = objDescribeFieldMap.get(allowedFieldFromCs.fieldName__c).getDescribe();
                    if (temp.isAccessible())
                    {
                        // if reference add reference
                        if (temp.getType() == Schema.DisplayType.Reference) {
                            for (Schema.SObjectType reference : temp.getReferenceTo()) {
                                results.add(new FieldValueWrapper(temp.getLabel(), temp.getName(), reference.getDescribe().getName(), temp.getRelationshipName()));
                           }
                        }
                        results.add(new FieldValueWrapper(temp.getLabel(), temp.getName(), null, null));
                    }
                }
            }
        }
        // Otherwise we get the defaults values and labels for the requested object
        else
        {  
            List<Schema.SObjectField> fields = objDescribeFieldMap.Values();
            for (Schema.SObjectField field : fields)
            {
                Schema.DescribeFieldResult temp = field.getDescribe();
                if (temp.isAccessible())
                {
                    // if reference add reference
                    if (temp.getType() == Schema.DisplayType.Reference) {
                        for(Schema.SObjectType reference : temp.getReferenceTo()) {
                            results.add(new FieldValueWrapper(temp.getLabel(), temp.getName(), reference.getDescribe().getName(), temp.getRelationshipName()));
                       }
                    }
                    results.add(new FieldValueWrapper(temp.getLabel(), temp.getName(), null, null));
                }
            }
        }        
        results.sort();
        serializedResults = JSON.serializePretty(results);
        return serializedResults;
    }
    
    /* --------------------------------------------------------------------------------------------
    ** This method returns the type of a field
    ** and return it as a List<ValueWrapper> serialized in JSON
    ** ----------------------------------------------------------------------------------------- */
    @AuraEnabled
    public static String getFieldType(String sObjectName, String fieldApiName)
    {
        Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
        Schema.SObjectType objType = objGlobal.get(sObjectName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();
        
        if (objDescribeFieldMap.get(fieldApiName) == null) {
            return null;
        }

        Schema.DescribeFieldResult fieldResult = objDescribeFieldMap.get(fieldApiName).getDescribe();
        LC102_3C_CriteriaWrapper.FieldTypeWrapper res = LC102_3C_CriteriaWrapper.mapInformation.get(fieldResult.getType());

        if (res != null) {
            res.init(fieldResult, sObjectName, fieldApiName);
            return JSON.serializePretty(res);
        }
        return JSON.serializePretty(LC102_3C_CriteriaWrapper.mapInformation.get(Schema.DisplayType.String));
    }
    

    
    
    /* --------------------------------------------------------------------------------------------
    ** VALUE WRAPPER CLASS - object for field values 
    ** ----------------------------------------------------------------------------------------- */
    
    global class FieldValueWrapper implements Comparable 
    {
        public String label;
        public String apiName;
        public Boolean isReference;
        public String sObjectName;
        public String relationshipName;
        
        global Integer compareTo(Object compareTo) 
        {
            FieldValueWrapper fieldValueWrapper = (FieldValueWrapper) compareTo;
            return this.label.compareTo(fieldValueWrapper.label);
        }
        
        public FieldValueWrapper(String label, String apiName, String objectName, String relationshipName)
        {
            this.label = label;
            this.apiName = apiName;

            // lookup, get ObjectName
            this.isReference = (objectName == '' || objectName == null) ? false : true;
            this.sObjectName = objectName;
            this.relationshipName = relationshipName;
        }
    }
}