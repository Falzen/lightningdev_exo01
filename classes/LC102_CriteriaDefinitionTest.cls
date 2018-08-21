@isTest
public class LC102_CriteriaDefinitionTest
{
    @testSetup
    public static void setup()
    {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String myProflieName = PROFILE[0].Name;

        List<CS102_3C_CriteriaDefinitionFields__c> criteriaDefinitions = New List<CS102_3C_CriteriaDefinitionFields__c>();
        CS102_3C_CriteriaDefinitionFields__c criteriaDefinition = new CS102_3C_CriteriaDefinitionFields__c(); 
        criteriaDefinition.Name = 'Phone';
        criteriaDefinition.fieldName__c = 'Phone';
        criteriaDefinition.listName__c = 'listaccount';
        criteriaDefinition.profiles__c = myProflieName;
        criteriaDefinition.sObjectName__c = 'Account';
        criteriaDefinition.users__c = ' ';
        criteriaDefinitions.add(criteriaDefinition);

        CS102_3C_CriteriaDefinitionFields__c criteriaDefinition2 = new CS102_3C_CriteriaDefinitionFields__c(); 
        criteriaDefinition2.Name = 'OwnerId';
        criteriaDefinition2.fieldName__c = 'OwnerId';
        criteriaDefinition2.listName__c = 'listaccount';
        criteriaDefinition2.profiles__c = myProflieName;
        criteriaDefinition2.sObjectName__c = 'Account';
        criteriaDefinition2.users__c = ' ';
        criteriaDefinitions.add(criteriaDefinition2);

        insert criteriaDefinitions;
    }

    @isTest
    public static void getObjectFieldsTest()
    {
        // get filds list to Object for creat Criterion
        List<LC102_3C_CriteriaDefinition.FieldValueWrapper> results = (List<LC102_3C_CriteriaDefinition.FieldValueWrapper>)JSON.deserialize(LC102_3C_CriteriaDefinition.getObjectFields('Account', 'listaccount'), List<LC102_3C_CriteriaDefinition.FieldValueWrapper>.class);
        System.assert(results.size() > 0);
        List<LC102_3C_CriteriaDefinition.FieldValueWrapper> results2 = (List<LC102_3C_CriteriaDefinition.FieldValueWrapper>)JSON.deserialize(LC102_3C_CriteriaDefinition.getObjectFields('Account', 'listaccount2'), List<LC102_3C_CriteriaDefinition.FieldValueWrapper>.class);
        System.assert(results2.size() > 0);
    }

    @isTest
    public static void getFieldType()
    {
        // get List Operator for the type field ObjectName
        LC102_3C_CriteriaWrapper.FieldTypeWrapper fieldType = (LC102_3C_CriteriaWrapper.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Account', 'Name'), LC102_3C_CriteriaWrapper.FieldTypeWrapper.class);
        System.assertEquals(fieldType.operators[0].label, 'Equals');

        String test = LC102_3C_CriteriaDefinition.getFieldType('Account', 'NameExistePas');
        System.assertEquals(test, null);
    }
    

    @isTest
    public static void getCriteriaObjectNullable()
    {
        LC102_3C_CriteriaWrapper.CriteriaObject criterion = new LC102_3C_CriteriaWrapper.CriteriaObject();
        criterion.selectAuraId = 'test';
        criterion.lookupFieldQuery = 'test';
        criterion.lookupFieldValue = 'test';
        criterion.fieldName = 'test';
        criterion.fieldType = 'test';
        criterion.displayType = 'test';
        criterion.parentObjectName = 'test';
        criterion.operator = 'test';
        criterion.initValues  = null;
        criterion.selectedValue = 'test';
        criterion.order  = 0;
        criterion.logicNumber  = 0;
        criterion.lookupObjectName  = 'test';
        criterion.available = true;
        criterion.sObjectNames = new List<String>();
        criterion.relationshipNames = new List<String>();

        System.assertEquals(criterion.getFieldTypeWrapper(), null);
        System.assertEquals(criterion.getOperator(), null);
        System.assertEquals(criterion.getWhere('test'), '');
    }

    @isTest
    public static void getCriteriaObjectExiste()
    {
        LC102_3C_CriteriaWrapper.CriteriaObject criterion = new LC102_3C_CriteriaWrapper.CriteriaObject();
        criterion.selectAuraId = 'test';
        criterion.lookupFieldQuery = 'test';
        criterion.lookupFieldValue = 'test';
        criterion.fieldName = 'test';
        criterion.fieldType = 'Phone';
        criterion.displayType = 'test';
        criterion.parentObjectName = 'test';
        criterion.operator = 'Equals';
        criterion.initValues  = null;
        criterion.selectedValue = 'test';
        criterion.order  = 0;
        criterion.logicNumber  = 0;
        criterion.lookupObjectName  = 'test';
        criterion.available = true;
        criterion.sObjectNames = new List<String>();
        criterion.relationshipNames = new List<String>();

        System.assertEquals(criterion.getFieldTypeWrapper(), LC102_3C_CriteriaWrapper.mapInformation.get(Schema.DisplayType.Phone));
        // System.assertEquals(criterion.getOperator(), new LC102_3C_CriteriaWrapper.OperatorObject('Equals', Type.TEXT, '=', 'AND', '', ''));
        System.assertEquals(criterion.getWhere(''), '( test = \'test\' )');
    }

    @isTest
    public static void getSearchObject()
    {
        LC102_3C_CriteriaWrapper.SearchObject searchObject = new LC102_3C_CriteriaWrapper.SearchObject();
        
        searchObject.columnFieldToSort = 0;
        searchObject.sortMethod = 'ASC';
        searchObject.criteria = null;
        searchObject.limitDisplay = 25;
        searchObject.limitQuery = 1000;
        searchObject.listName = 'test';
        searchObject.logicString = 'test';
        searchObject.offset = 0;
        searchObject.parentObjectName = 'Case';
    }

    /*
    @isTest
    public static void getFieldType()
    {
        List<String> STATIC_OPERATORS = new List<String> {'Equals', 'Contains', 'Starts', 'Ends'};
        List<String> STATIC_DATE_OPERATORS = new List<String> {'Equals', 'Starts', 'Ends'};
        List<String> STATIC_CHECKBOX_OPERATORS = new List<String> {'Equals'};
                    
        LC102_3C_CriteriaDefinition.FieldTypeWrapper expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper('PICKLIST', 'picklist', null, STATIC_OPERATORS);
        LC102_3C_CriteriaDefinition.FieldTypeWrapper actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Case', 'Status'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);
        
        Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
        Schema.SObjectType objType = objGlobal.get('Case');
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();        
        
        Schema.DescribeFieldResult fieldResult = objDescribeFieldMap.get('OwnerId').getDescribe();
        
        List<String> lookupObjectNames = new List<String>();
        for(Schema.SObjectType reference : fieldResult.getReferenceTo()) {
            lookupObjectNames.add(reference.getDescribe().getName());
        }

        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Reference+'', 'lookup', lookupObjectNames, STATIC_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Case', 'OwnerId'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);
        
        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Email+'', 'text', null, STATIC_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Case', 'ContactEmail'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);
        
        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Datetime+'', 'datetime', null, STATIC_DATE_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Case', 'ClosedDate'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);        
        
        
        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Date+'', 'date', null, STATIC_DATE_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Contact', 'Birthdate'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);        

        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Time+'', 'time', null, STATIC_DATE_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('BusinessHours', 'SaturdayEndTime'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);        

        
        expected = new LC102_3C_CriteriaDefinition.FieldTypeWrapper(Schema.DisplayType.Boolean+'', 'checkbox', null, STATIC_CHECKBOX_OPERATORS);
        actual = (LC102_3C_CriteriaDefinition.FieldTypeWrapper)JSON.deserialize(LC102_3C_CriteriaDefinition.getFieldType('Case', 'IsClosedOnCreate'), LC102_3C_CriteriaDefinition.FieldTypeWrapper.class);
        
        System.assertEquals(expected.displayType, actual.displayType);
        System.assertEquals(expected.fieldType, actual.fieldType);
        System.assertEquals(expected.lookupObjectNames, actual.lookupObjectNames);
        System.assertEquals(expected.operators, actual.operators);        
    }

    */
}