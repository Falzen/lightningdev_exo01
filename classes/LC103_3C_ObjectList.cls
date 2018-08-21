public class LC103_3C_ObjectList
{   
    /**
    ** Recupération de la liste des objet qui on notre objet pour afficher le tableau
    **/
    @AuraEnabled
    public static List<ChildObject> getChilden(String sObjectName, String listName, Boolean selectAllTheFields)
    {
        // recuperation des object qui on un champ "sObjectName"
        List<ChildObject> childenList = new List<ChildObject>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(sObjectName);

        Schema.DescribeSObjectResult R = objType.getDescribe();
        for (Schema.ChildRelationship cr: R.getChildRelationships()) {
            Schema.SObjectField field = cr.getField();
            Schema.DescribeFieldResult temp = field.getDescribe();
            // add childen if accessible and not relationshipname
            if (temp.isAccessible() && temp.getRelationshipName() != null) {
                childenList.add(new ChildObject(''+cr.getChildSObject(), cr.getRelationshipName(), ''+cr.getField(), temp.getRelationshipName()));
            }
        }

        if (!selectAllTheFields) {
            String userLike = '%'+UserInfo.getName()+'%';
            String profileLike = '%'+[SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()][0].Name +'%';
            
            List<CS103_3C_ObjectListColumns__c> columns = [
                SELECT fieldApiName__c, isCheckbox__c, isImage__c, isRadioButton__c, sObjectName__c
                    FROM CS103_3C_ObjectListColumns__c
                    WHERE ListName__c = :listName
                        AND (profiles__c LIKE :profileLike OR users__c LIKE :userLike)
            ];
   
            Set<String> listObject = new Set<String>();

            // List All Object have a column
            for (CS103_3C_ObjectListColumns__c column : columns) {
                if (!listObject.contains(column.sObjectName__c)) {
                    listObject.add(column.sObjectName__c);
                }
            }

            // Select Object in the ObjectList Childen.
            List<ChildObject> childenListTmp = new List<ChildObject>();
            for (ChildObject child : childenList) {
                if (listObject.contains(child.objectName)) {
                    childenListTmp.add(child);
                }
            }
            childenList = childenListTmp;
        }


        return childenList;
    }
    
    /*
    ** Method that returns the type of a field
    ** @params sObjectName String: Name Object
    ** @params fieldApiName String: fieldName object or relationship (Owner.LastName)
    */
    public static String getFieldType(String sObjectName, String fieldApiName)
    {
        Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();

        String[] reference = fieldApiName.split('\\.');
        Schema.DescribeFieldResult fieldResult = null;


        try {
            // is not relationship, search type of fields in Object
            if (reference.size() < 2) {
                Schema.SObjectType objType = objGlobal.get(sObjectName);
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();
                fieldResult = objDescribeFieldMap.get(fieldApiName).getDescribe();
                return ''+fieldResult.getType();
            }

            // Find type to RelationShip in Object ex: Owner.LastName, LastModifyBy.Owner.Name, ...
            for (Integer i = 0; i < reference.size(); i++) {
                Schema.SObjectType objType = objGlobal.get(sObjectName);
                List<Schema.SObjectField> fieldList = objType.getDescribe().fields.getMap().values();
                
                // is last child, is filds (LastName, Name, ...)
                if (i == reference.size() - 1) {
                    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                    Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();
                    fieldResult = objDescribeFieldMap.get(reference[i]).getDescribe();
                    return ''+fieldResult.getType();
                }

                // Search ObjectName Relationship in field List to Object 
                for (Schema.SObjectField field : fieldList) {
                    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                    
                    if (fieldDesc.getType() == Schema.DisplayType.Reference) {
                        
                        // find ObjectName to Lookup / Reference
                        for (Schema.SObjectType temp : fieldDesc.getReferenceTo()) {
                            if ( fieldDesc.getRelationshipName() == reference[i]) {
                                sObjectName = temp.getDescribe().getName();
                            }
                        }
                    }
                }
            }
        } catch( Exception error){
            system.debug('ERROR REFERENCE N\'EXISTE PAS : ' + error.getMessage());
        }
        return 'text';
    }
    
    //Method that gets fields from custom settings
    public static Map<String, String> getSpecialFieldsFromCS(String sObjectName, String listName)
    {
        Map<String, String> specialFields = new Map<String, String>();
        
        String userLike = '%'+UserInfo.getName()+'%';
        String profileLike = '%'+[SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()][0].Name +'%';
        
        List<CS103_3C_ObjectListColumns__c> columns = [
            SELECT fieldApiName__c, isCheckbox__c, isImage__c, isRadioButton__c
            FROM CS103_3C_ObjectListColumns__c
            WHERE ListName__c = :listName AND sObjectName__c = :sObjectName
                AND (profiles__c LIKE :profileLike OR users__c LIKE :userLike)
        ];

        // parsing column to special Image, Checkbox, ...
        for (CS103_3C_ObjectListColumns__c column : columns) {
            if (column.isImage__c) {
                specialFields.put(column.FieldApiName__c, 'image');
            } else if (column.isCheckbox__c) {
                specialFields.put(column.FieldApiName__c, 'checkbox');
            } else if (column.isRadioButton__c) {
                specialFields.put(column.FieldApiName__c, 'radioButton');
            }
        }
        
        return specialFields;
    }
    
    /*
    ** Method that returns columns from custom settings and taking sObjectName and listName as parameters
    */
    public static List<ColumnObject> getColumnsFromCustomSettings(String sObjectName, String listName)
    {
        List<ColumnObject> results = new List<ColumnObject>();
        List<CS103_3C_ObjectListColumns__c> columns = new List<CS103_3C_ObjectListColumns__c>();
        
        String userLike = '%'+UserInfo.getName()+'%';
        String profileLike = '%'+[SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()][0].Name	+'%';
        
        columns = [
            SELECT Name, ListName__c, sObjectName__c, fieldApiName__c, fieldName__c, isCheckbox__c,
                   isImage__c, isRadioButton__c, isSortable__c, Order__c
            FROM CS103_3C_ObjectListColumns__c
            WHERE ListName__c = :listName
                AND sObjectName__c = :sObjectName
                AND (profiles__c LIKE :profileLike OR users__c LIKE :userLike)
        ];
                
        for (CS103_3C_ObjectListColumns__c column : columns)
        {
            ColumnObject columnObject = new ColumnObject();
            columnObject.fieldName = column.FieldName__c;
            columnObject.fieldApiName = column.FieldApiName__c;
            columnObject.isCheckbox = column.isCheckbox__c;
            columnObject.isImage = column.isImage__c;
            columnObject.isRadioButton = column.isRadioButton__c;
            columnObject.isSortable = column.isSortable__c;
            columnObject.order = Integer.valueOf(column.Order__c);
            columnObject.isDatabased = true;
            columnObject.isDisplay = true;  
            
            if (!columnObject.isCheckbox && !columnObject.isRadioButton) {
                columnObject.isDatabased = true;
                columnObject.fieldType = LC103_3C_ObjectList.getFieldType(sObjectName, columnObject.fieldApiName);
            }
            results.add(columnObject);
        }
        return results;
    }
    
    /*
    ** Method that returns columns from all the fields
    ** @params ObjectNamme String: Name Object
    ** @params listName
    */
    public static List<ColumnObject> getColumnsFromAllFields(String sObjectName, String listName)
    {
        List<ColumnObject> results = new List<ColumnObject>();   
        
        Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
        Schema.SObjectType objType = objGlobal.get(sObjectName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();        
        List<Schema.SObjectField> fields = objDescribeFieldMap.Values();            
        Map<String, String> specialFields = getSpecialFieldsFromCS(sObjectName, listName);
        
        Integer i = 0;
        
        for (Schema.SObjectField field : fields)
        {
            Schema.DescribeFieldResult temp = field.getDescribe();
            if (temp.isAccessible())
            {                
                ColumnObject columnObject = new ColumnObject();
                columnObject.fieldName = temp.getLabel();
                columnObject.fieldApiName = temp.getName();
                
                columnObject.isImage = false;                
                columnObject.isCheckbox = false;
                columnObject.isRadioButton = false;
                
                if (specialFields.get(temp.getName()) == 'checkbox') {
                    columnObject.isCheckbox = true;                    
                } else if (specialFields.get(temp.getName()) == 'image') {
                    columnObject.isImage = true;                    
                } else if (specialFields.get(temp.getName()) == 'radioButton') {
                    columnObject.isRadioButton = true;                    
                }
                
                columnObject.isSortable = true;
                columnObject.order = i++;
                columnObject.isDatabased = true;                    
                columnObject.isDisplay = true;              
                
                if (!columnObject.isCheckbox && !columnObject.isRadioButton) {
                    columnObject.isDatabased = true;
                    columnObject.fieldType = LC103_3C_ObjectList.getFieldType(sObjectName, columnObject.fieldApiName);
                } else {
                    columnObject.fieldType = 'custom';
                }

                results.add(columnObject);                                
            }
        } 
        
        return results;
    }

    //This method gets all columns and sends a serialized list of "ColumnObject"
    @AuraEnabled
    public static List<ColumnObject> getColumns(String sObjectName, String listName, Boolean selectAllTheFields)
    {
        List<ColumnObject> results = new List<ColumnObject>();
        
        if (listName != null && sObjectName != null && sObjectName != '' && listName != '') {
            if (selectAllTheFields) {
                results = getColumnsFromAllFields(sObjectName, listName);
            } else {
                results = getColumnsFromCustomSettings(sObjectName, listName);
            }
        }
        
        return results;
    }
    
    //This method construct WHERE clause condition 
    public static String getWhereQueryFromSearchObject(SearchObject searchObject, String fieldNameChilden)
    {
        String whereQuery = ' ';
                
        if (searchObject != null && searchObject.criteria != null && searchObject.criteria.size() > 0) {
            List<String> requestWhere = new List<String>();
            
            // transoforme criterion from request
            for (LC102_3C_CriteriaWrapper.CriteriaObject criterion : searchObject.criteria) {
                String req = criterion.getWhere(fieldNameChilden);
                if (req != '') {
                    requestWhere.add(req);
                }
            }

            // check request exist
            if (requestWhere.size() <= 0) {
                return ' ';
            }

            if (searchObject.logicString != null && searchObject.logicString != '') {
                try {
                    String chaines = String.format(searchObject.logicString, requestWhere);
                    return ' WHERE ' + chaines;
                } catch (QueryException e ) {
                    System.debug( e.getMessage() );
                }
            }

            whereQuery += 'WHERE ';

            // Creation de la request
            for (String str : requestWhere) {

                whereQuery += str + ' AND';
            }
            whereQuery = whereQuery.removeEnd('AND');
        }

        return whereQuery;    
    }

    // return ORDER BY condition
    public static string getOrderParsing(List<ColumnObject> columnss, SearchObject searchObject) {
        // verification exist params sort
        if (searchObject.sortMethod != 'ASC' && searchObject.sortMethod != 'DESC' && searchObject.columnFieldToSort != -1)  {
            return '';
        }

        // find colomn exist to sort
        for (ColumnObject column : columnss) {
            // order with null to last
            if (column.order == searchObject.columnFieldToSort) {
                return  ' ORDER BY ' + column.fieldApiName + ' ' + searchObject.sortMethod + ' NULLS LAST';
            }
        }
        return '';
    }

    public static String constructQuerySelect(List<ColumnObject> columnss)
    {
        //The search Query
        String querySelect = 'SELECT ';

        // select all
        if (columnss.size() == 0) {
            querySelect += ' * ';
        } else {
            // construct fieldName1, FieldName2
            for (ColumnObject column : columnss) {
                querySelect += column.fieldApiName+', ';
            }
            querySelect = querySelect.removeEnd(', ');
        }

        return querySelect;
    }
    
    //Method that execute the search after launch of the search
    @AuraEnabled
    public static String executeSearch(String serializedColumns, String sObjectName, String serializedSearchObject, String logic)
    {
        List<ColumnObject> columnss = (List<ColumnObject>) JSON.deserialize(serializedColumns, List<ColumnObject>.class);
        SearchObject searchObject = new SearchObject();
        
        if (serializedSearchObject != null && serializedSearchObject != ''){
            searchObject = (SearchObject) JSON.deserialize(serializedSearchObject, LC103_3C_ObjectList.SearchObject.class); 
        }
        
        //Reassign the searchObject value that was empty                
        ResultList dataResults = new ResultList();
        
        String query = '';

        //The search Query
        String querySelect = constructQuerySelect(columnss);
        String queryLimit = ' LIMIT ' + searchObject.limitDisplay + ' OFFSET ' + searchObject.offset;

        // parsing childen with actuel object  (Account) -> History.accountId
        List<String> parentObject = searchObject.parentObjectName.split('-');
        List<sObject> sObjects = null;

        if (parentObject.size() > 3) {
            String objectName = parentObject[0];
            String relationTo = parentObject[1];
            String fieldName = parentObject[2];
            String relationshipName = parentObject[3];

            if (objectName == sObjectName) {
                // WHERE Parent.Id = ... AND Parent.Name = 'zfe'
                query = ' FROM ' + objectName + ' ' + getWhereQueryFromSearchObject(searchObject, relationshipName + '.');
            } else {
                // SELECT .... FROM ObjetChilden WHERE Parent.ID IN (SELECT ID FROM Object ...)
                query =  'SELECT Id FROM ' +sObjectName + getWhereQueryFromSearchObject(searchObject, '');
                query = ' FROM ' + objectName + ' WHERE '+fieldName+' IN (' + query + ') ';
            }
        } else {
            // FROM .. WHERE ....
            query +=  ' FROM ' +sObjectName ; 
            query += getWhereQueryFromSearchObject(searchObject, '');
        }

        dataResults.count = Database.countQuery('SELECT COUNT() ' + query);
        query += getOrderParsing(columnss, searchObject);

        sObjects = Database.query(querySelect + query + queryLimit);

        //display the result through "serializedResults" 
        try{
            for (sObject obj : sObjects)
            {
                ResultObject result = new ResultObject();
                result.active = false;
                List<ColumnObject> fields = new List<ColumnObject>();
                result.Id = obj.Id;
                result.sObjectName = sObjectName;
                
                for (ColumnObject column : columnss)
                {
                    ColumnObject field = new ColumnObject(column);
                    String[] fieldsSplit = column.fieldApiName.split('\\.');

                    // if field is not a owner.lastname (reference)
                    if (fieldsSplit.size() < 2) {
                        field.value = String.valueOf(obj.get(column.fieldApiName)); 
                    } else {
                        //search value in the sObject
                        sObject acc = obj;
                        for (Integer i = 0; i < fieldsSplit.size(); i++) {
                            if (i == fieldsSplit.size() - 1)
                                field.value = String.valueOf(acc.get(fieldsSplit[i]));
                            else
                                acc = acc.getSobject(fieldsSplit[i]);
                        }
                    }
                    fields.add(field);
                }
                
                result.fields = fields;
                dataResults.results.add(result);
            }

            String serializedResults = '';
            serializedResults = JSON.serializePretty(dataResults);        
            
            return serializedResults;
        }catch( Exception error){
            system.debug('error'+error.getMessage());
            return null;
        }
    }

    /* --------------------------------------------------------------------------------------------
    ** ResultList Class definition - object for result List
    ** ----------------------------------------------------------------------------------------- */
    public class ResultList
    {
        @AuraEnabled public List<ResultObject> results; // results rows
        @AuraEnabled public Integer count;  // number total of rows in database

        public ResultList() {
            this.results = new  List<ResultObject>();
            this.count = 0;
        }
    }
    
    /* --------------------------------------------------------------------------------------------
    ** ResultObject Class definition - object for result
    ** ----------------------------------------------------------------------------------------- */   
    
    public class ResultObject 
    {
        @AuraEnabled public Id Id {get; set;}                       // SObject.id
        @AuraEnabled public Boolean active {get; set;}              // for the Mass Action, rows is selected
        @AuraEnabled public String sObjectName {get; set;}          // ObjectName
        @AuraEnabled public List<ColumnObject> fields {get; set;}   // Column information
        @AuraEnabled public String fieldName{get; set;}             // ?
        @AuraEnabled public String fieldApiName{get; set;}          // ?
        @AuraEnabled public String value{ get; set;}                // ?
    }
    
    
    /* --------------------------------------------------------------------------------------------
    ** ColumnObject Class definition - object for column
    ** ----------------------------------------------------------------------------------------- */   
    
    public class ColumnObject
    {
        @AuraEnabled public String fieldName{get; set;}     // fieldName
        @AuraEnabled public String fieldApiName{get; set;}  // fieldApiName
        @AuraEnabled public String fieldType{get; set;}     // field type
        @AuraEnabled public Boolean isSortable{get; set;}   // is sortable in table
        @AuraEnabled public String value{ get; set;}        // value to field
        @AuraEnabled public Integer order{get; set;}        // order to column
        @AuraEnabled public Boolean isImage{get; set;}      // value is image
        @AuraEnabled public Boolean isCheckbox{get; set;}   // value is checkbox
        @AuraEnabled public Boolean isRadioButton{get; set;}// ?
        @AuraEnabled public Boolean isDatabased{get; set;}  // ?
        @AuraEnabled public Boolean isDisplay{get; set;}  // Display column

        public ColumnObject() {}
        public ColumnObject(ColumnObject column) {
            this.fieldName = column.fieldName;
            this.fieldApiName = column.fieldApiName;
            this.fieldType = column.fieldType;
            this.isSortable = column.isSortable;
            this.value = column.value;
            this.order = column.order;
            this.isImage = column.isImage;
            this.isCheckbox = column.isCheckbox;
            this.isRadioButton = column.isRadioButton;
            this.isDatabased = column.isDatabased;
            this.isDisplay = column.isDisplay;
        }
    }
    
    
    /* --------------------------------------------------------------------------------------------
    ** SearchObject Class definition - object for searchObject
    ** ----------------------------------------------------------------------------------------- */   
    public class SearchObject
    {
        @AuraEnabled public Integer columnFieldToSort {get; set;}   // position column
        @AuraEnabled public Integer limitDisplay {get; set;}        // limit row display
        @AuraEnabled public Integer limitQuery {get; set;}          // limit query in bdd
        @AuraEnabled public Integer offset {get; set;}              // 
        @AuraEnabled public String listName {get; set;}             // custom object - name
        @AuraEnabled public String logicString {get; set;}          // logic - 1 OR 2 AND 3
        @AuraEnabled public String parentObjectName {get; set;}     // Object search
        @AuraEnabled public String sortMethod {get; set;}           // ASC or DESC
        @AuraEnabled public List<LC102_3C_CriteriaWrapper.CriteriaObject> criteria {get; set;}
    }

    /* --------------------------------------------------------------------------------------------
    ** ChildObject - relation object childen with object parent
    ** ----------------------------------------------------------------------------------------- */   
    public class ChildObject
    {
        @AuraEnabled
        public String objectName { get; set; }  // ObjectName
        @AuraEnabled
        public String relationTo { get; set; }  // Object relation 
        @AuraEnabled
        public String fieldName { get; set; }   // Name field of relation - ex: Account.ownerId
        @AuraEnabled
        public String relationshipName { get; set; }   // Name field of relation - ex: Account.owner

        public ChildObject(String objectName, String relationTo, String fieldName, String relationshipName) {
            this.objectName = objectName;
            this.relationTo = relationTo;
            this.fieldName = fieldName;
            this.relationshipName = relationshipName;
        }
    }
}

//if (temp.getType() == Schema.DisplayType.Reference) {
//    for(Schema.SObjectType reference : temp.getReferenceTo()) {
//        childenList.add(new ChildObject(''+cr.getChildSObject(), cr.getRelationshipName(), ''+cr.getField(), '' + reference.getDescribe().getName()));
//        //results.add(new FieldValueWrapper(temp.getLabel(), temp.getName(), reference.getDescribe().getName(), temp.getRelationshipName()));
//   }
//} else {
//}