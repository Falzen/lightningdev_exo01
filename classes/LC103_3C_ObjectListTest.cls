@isTest
public class LC103_3C_ObjectListTest {
    public class Factory
    {
        CS103_3C_ObjectListColumns__c getObjectListColumns()
        {
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String myProflieName = PROFILE[0].Name;
            
            CS103_3C_ObjectListColumns__c objectListColumn = new CS103_3C_ObjectListColumns__c(); 
            objectListColumn.Name = 'Website';
            objectListColumn.FieldApiName__c = 'Website';
            objectListColumn.FieldName__c = 'Website';
            objectListColumn.isCheckbox__c = true;
            objectListColumn.isImage__c = false;
            objectListColumn.isRadioButton__c = false;
            objectListColumn.isSortable__c = true;
            objectListColumn.ListName__c = 'listaccountTest';
            objectListColumn.Order__c = 6;
            objectListColumn.Profiles__c = myProflieName;
            objectListColumn.sObjectName__c = 'Account';
            objectListColumn.Users__c = '';
            return objectListColumn;
        }

        LC102_3C_CriteriaWrapper.CriteriaObject getCriteriaObject()
        {
            LC102_3C_CriteriaWrapper.CriteriaObject criterion = new LC102_3C_CriteriaWrapper.CriteriaObject();
            criterion.selectAuraId = 'Name';
            criterion.lookupFieldQuery = 'Name';
            criterion.lookupFieldValue = 'Name';
            criterion.fieldName = 'Name';
            criterion.fieldType = 'String';
            criterion.displayType = 'text';
            criterion.parentObjectName = 'Account.Account';
            criterion.operator = 'Contains';
            criterion.initValues  = null;
            criterion.selectedValue = '';
            criterion.order  = 0;
            criterion.logicNumber  = 0;
            criterion.lookupObjectName  = 'Name';
            criterion.available = true;
            criterion.sObjectNames = new List<String>();
            criterion.relationshipNames = new List<String>();
            return criterion;
        }
    }


    @testSetup
    public static void setup()
    {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String myProflieName = PROFILE[0].Name;

        List<Account> accts = new List<Account>();
        accts.add(new Account(Name='SFDC Account'));
        accts.add(new Account(Name='SFDC Account 2'));
        accts.add(new Account(Name='SFDC Account 3'));
        insert accts;

        System.debug('Name: ' + UserInfo.getName());
        List<CS103_3C_ObjectListColumns__c> objectListColumns = New List<CS103_3C_ObjectListColumns__c>();
        CS103_3C_ObjectListColumns__c objectListColumn = new CS103_3C_ObjectListColumns__c(); 
        objectListColumn.Name = 'Website';
        objectListColumn.FieldApiName__c = 'Website';
        objectListColumn.FieldName__c = 'Website';
        objectListColumn.isCheckbox__c = true;
        objectListColumn.isImage__c = false;
        objectListColumn.isRadioButton__c = false;
        objectListColumn.isSortable__c = true;
        objectListColumn.ListName__c = 'listaccountTest';
        objectListColumn.Order__c = 6;
        objectListColumn.Profiles__c = myProflieName;
        objectListColumn.sObjectName__c = 'Account';
        objectListColumn.Users__c = '';
        objectListColumns.add(objectListColumn);

        CS103_3C_ObjectListColumns__c objectListColumn2 = new CS103_3C_ObjectListColumns__c(); 
        objectListColumn2.Name = 'Phone';
        objectListColumn2.FieldApiName__c = 'Phone';
        objectListColumn2.FieldName__c = 'Phone';
        objectListColumn2.isCheckbox__c = false;
        objectListColumn2.isImage__c = false;
        objectListColumn2.isRadioButton__c = true;
        objectListColumn2.isSortable__c = true;
        objectListColumn2.ListName__c = 'listaccountTest';
        objectListColumn2.Order__c = 7;
        objectListColumn2.Profiles__c = myProflieName;
        objectListColumn2.sObjectName__c = 'Account';
        objectListColumn2.Users__c = '';
        objectListColumns.add(objectListColumn2);

        objectListColumns.add(new CS103_3C_ObjectListColumns__c(
            Name = 'Owner.Name',
            FieldApiName__c = 'Owner.Name',
            FieldName__c = 'Owner.Name',
            isCheckbox__c = false,
            isImage__c = true,
            isRadioButton__c = false,
            isSortable__c = true,
            ListName__c = 'listaccountTest',
            Order__c = 8,
            Profiles__c = myProflieName,
            sObjectName__c = 'Account',
            Users__c = ''
        ));

        insert objectListColumns;
    }


	@isTest
    public static void getFieldType()
    {
		// TEST TO SEARCH TYPE OF FIELD IN OBJECT CLASS AND RELATIONSHIP
    	System.assertEquals('STRING', LC103_3C_ObjectList.getFieldType('Account', 'Name'));
    	System.assertEquals('PICKLIST',  LC103_3C_ObjectList.getFieldType('Account', 'AccountSource'));
    	System.assertEquals('INTEGER', LC103_3C_ObjectList.getFieldType('Account', 'NumberOfEmployees'));
    	System.assertEquals('STRING', LC103_3C_ObjectList.getFieldType('Account', 'Owner.LastName'));
    	System.assertEquals('ID', LC103_3C_ObjectList.getFieldType('Account', 'Owner.ID'));
	}

	@isTest
    public static void getOrderParsing()
    {
		//LC103_3C_ObjectList.getOrderParsing(List<ColumnObject> columnss, SearchObject searchObject);
	}

    @isTest
    public static void getSpecialFieldsFromCS()
    {
        // parse Special Column
        System.assertEquals(LC103_3C_ObjectList.getSpecialFieldsFromCS('Account', 'listaccountTest').size(), 3);
        System.assertEquals(LC103_3C_ObjectList.getSpecialFieldsFromCS('Account', 'listaccount').size(), 0);
    }

    @isTest
    public static void getColumnsFromCustomSettings()
    {
        // get column setting
        System.assertEquals(LC103_3C_ObjectList.getColumnsFromCustomSettings('Account', 'listaccountTest').size(), 3);
        System.assertEquals(LC103_3C_ObjectList.getColumnsFromCustomSettings('Account', 'listaccount').size(), 0);
    }

    @isTest
    public static void getColumnsFromAllFields()
    {
        // get all column
        System.assert(LC103_3C_ObjectList.getColumnsFromAllFields('Account', 'listaccount').size() > 0);
        System.assert(LC103_3C_ObjectList.getColumnsFromAllFields('Account', '').size() > 30);
    }

    @isTest
    public static void getColumns()
    {
        // get all column
        System.assertEquals(LC103_3C_ObjectList.getColumns('Account', 'listaccountTest', false).size(), 3);
        System.assert(LC103_3C_ObjectList.getColumns('Account', 'listaccount', true).size() > 30);

        System.assertEquals(LC103_3C_ObjectList.getColumns('', 'listaccount', true).size(), 0);
        System.assertEquals(LC103_3C_ObjectList.getColumns('Account', '', true).size(), 0);
    }


    public static void createTestRecords(Integer numAccts, Integer numContactsPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];            
            // For each account just inserted, add contacts
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     AccountId=acct.Id));
            }
        }
        // Insert all contacts for all accounts
        insert cons;
    }

    @isTest
    public static void searchTest()
    {
        LC103_3C_ObjectListTest.createTestRecords(5, 3);

        LC102_3C_CriteriaWrapper.CriteriaObject criterion = new LC102_3C_CriteriaWrapper.CriteriaObject();
        criterion.selectAuraId = 'Name';
        criterion.lookupFieldQuery = 'Name';
        criterion.lookupFieldValue = 'Name';
        criterion.fieldName = 'Name';
        criterion.fieldType = 'String';
        criterion.displayType = 'text';
        criterion.parentObjectName = 'Account';
        criterion.operator = 'Contains';
        criterion.initValues  = null;
        criterion.selectedValue = '';
        criterion.order  = 0;
        criterion.logicNumber  = 0;
        criterion.lookupObjectName  = 'Name';
        criterion.available = true;
        criterion.sObjectNames = new List<String>();
        criterion.relationshipNames = new List<String>();

        LC103_3C_ObjectList.SearchObject searchObject = new LC103_3C_ObjectList.SearchObject();
        
        searchObject.columnFieldToSort = 0;
        searchObject.sortMethod = 'ASC';
        searchObject.criteria = null;
        searchObject.limitDisplay = 25;
        searchObject.limitQuery = 1000;
        searchObject.listName = 'test';
        searchObject.logicString = '{0} OR {0}';
        searchObject.offset = 0;
        searchObject.parentObjectName = 'Account';
        searchObject.criteria = new List<LC102_3C_CriteriaWrapper.CriteriaObject>();
        searchObject.criteria.add(criterion);

        Test.startTest();
        System.assertEquals(LC103_3C_ObjectList.getWhereQueryFromSearchObject(searchObject, ''), ' WHERE ( Name LIKE \'%%\' ) OR ( Name LIKE \'%%\' )');

        // Order test
        List<LC103_3C_ObjectList.ColumnObject> columnss = LC103_3C_ObjectList.getColumns('Account', 'listaccountTest', true);
        System.assertEquals(LC103_3C_ObjectList.getOrderParsing(columnss, searchObject), ' ORDER BY Id ASC NULLS LAST');
        System.assert(LC103_3C_ObjectList.executeSearch(JSON.serializePretty(columnss), 'Account', JSON.serializePretty(searchObject), null) != '');


        searchObject.logicString = null;
        System.assertEquals(LC103_3C_ObjectList.getWhereQueryFromSearchObject(searchObject, ''), ' WHERE ( Name LIKE \'%%\' ) ');


        //System.assertEquals(LC103_3C_ObjectList.executeSearch(JSON.serializePretty(columnss), 'Account', JSON.serializePretty(searchObject), null), '');

        //System.assertEquals(JSON.serializePretty(columnss), '');

        // public static String getWhereQueryFromSearchObject(SearchObject searchObject)
        // public static string getOrderParsing(List<ColumnObject> columnss, SearchObject searchObject) {
        // public static String executeSearch(String serializedColumns, String sObjectName, String serializedSearchObject, String logic)
        Test.stopTest();
    }

    @isTest
    public static void searchTestRelationship()
    {
        LC103_3C_ObjectListTest.createTestRecords(5, 3);

        LC102_3C_CriteriaWrapper.CriteriaObject criterion = new LC102_3C_CriteriaWrapper.CriteriaObject();
        criterion.selectAuraId = 'Name';
        criterion.lookupFieldQuery = 'Name';
        criterion.lookupFieldValue = 'Name';
        criterion.fieldName = 'Name';
        criterion.fieldType = 'String';
        criterion.displayType = 'text';
        criterion.parentObjectName = 'Account';
        criterion.operator = 'Contains';
        criterion.initValues  = null;
        criterion.selectedValue = '';
        criterion.order  = 0;
        criterion.logicNumber  = 0;
        criterion.lookupObjectName  = 'User';
        criterion.available = true;
        criterion.sObjectNames = new List<String>();
        criterion.relationshipNames = new List<String>();
        criterion.relationshipNames.add('Owner');

        LC102_3C_CriteriaWrapper.CriteriaObject criterion2 = new LC102_3C_CriteriaWrapper.CriteriaObject();
        criterion2.selectAuraId = 'AnnualRevenue';
        criterion2.lookupFieldQuery = 'AnnualRevenue';
        criterion2.lookupFieldValue = 'AnnualRevenue';
        criterion2.fieldName = 'AnnualRevenue';
        criterion2.fieldType = 'Integer';
        criterion2.displayType = 'number';
        criterion2.parentObjectName = 'Account';
        criterion2.operator = '>';
        criterion2.initValues  = null;
        criterion2.selectedValue = '0';
        criterion2.order  = 0;
        criterion2.logicNumber  = 0;
        criterion2.lookupObjectName  = 'Account';
        criterion2.available = true;
        criterion2.sObjectNames = new List<String>();
        criterion2.relationshipNames = new List<String>();

        LC103_3C_ObjectList.SearchObject searchObject = new LC103_3C_ObjectList.SearchObject();
        
        searchObject.columnFieldToSort = 8;
        searchObject.sortMethod = 'ASC';
        searchObject.criteria = null;
        searchObject.limitDisplay = 25;
        searchObject.limitQuery = 1000;
        searchObject.listName = 'test';
        searchObject.logicString = null;
        searchObject.offset = 0;
        searchObject.parentObjectName = 'Account';
        searchObject.criteria = new List<LC102_3C_CriteriaWrapper.CriteriaObject>();
        searchObject.criteria.add(criterion);
        searchObject.criteria.add(criterion2);

        System.assertEquals(LC103_3C_ObjectList.getWhereQueryFromSearchObject(searchObject, ''), ' WHERE ( Owner.Name LIKE \'%%\' ) AND( AnnualRevenue > 0 ) ');

        // Order test
        List<LC103_3C_ObjectList.ColumnObject> columnss = LC103_3C_ObjectList.getColumns('Account', 'listaccountTest', false);
        System.assertEquals(LC103_3C_ObjectList.getOrderParsing(columnss, searchObject), ' ORDER BY Owner.Name ASC NULLS LAST');
        System.assert(LC103_3C_ObjectList.executeSearch(JSON.serializePretty(columnss), 'Account', JSON.serializePretty(searchObject), null) != '');
    }

    @isTest
    public static void getChild()
    {
        System.assertEquals( LC103_3C_ObjectList.getChilden('Account', 'listaccount', false).size(), 0);  
        System.assertEquals( LC103_3C_ObjectList.getChilden('Account', 'listaccount', true).size(), 46);  
    }
}