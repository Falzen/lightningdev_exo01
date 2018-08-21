public class LC102_3C_CriteriaWrapper {


	/* --------------------------------------------------------------------------------------------
	** TYPE to parse Value Operator to SOQL
	** ----------------------------------------------------------------------------------------- */ 
	public enum Type { NUM , TEXT, DAT }


	/* --------------------------------------------------------------------------------------------
	** Define the operatos in static.
	** ----------------------------------------------------------------------------------------- */   
	private static final List<OperatorObject> STATIC_TEXT_OPERATORS = new List<OperatorObject> {
		new OperatorObject('Equals', Type.TEXT, '=', 'AND', '', ''),
		new OperatorObject('Contains', Type.TEXT, 'LIKE', 'AND', '%', '%'),
		new OperatorObject('Starts', Type.TEXT, 'LIKE', 'AND', '', '%'),
		new OperatorObject('Ends', Type.TEXT, 'LIKE', 'AND', '%', ''),
		new OperatorObject('not Contains', Type.TEXT, 'LIKE', 'AND', '%', '%', 'NOT')
	};
	
	private static final List<OperatorObject> STATIC_NUMBER_OPERATORS = new List<OperatorObject> {
		new OperatorObject('Equal', Type.NUM, '=', null),
		new OperatorObject('Not equal', Type.NUM, '!=', null),
		new OperatorObject('>', Type.NUM, '>', null),
		new OperatorObject('<', Type.NUM, '<', null),
		new OperatorObject('<=', Type.NUM, '<=', null),
		new OperatorObject('>=', Type.NUM, '>=', null)
	};

	private static final List<OperatorObject> STATIC_DATE_OPERATORS = new List<OperatorObject> {
		new OperatorObject('Equal', Type.DAT, '=', null),
		new OperatorObject('Not equal', Type.DAT, '!=', null),
		new OperatorObject('>', Type.DAT, '>', null),
		new OperatorObject('<', Type.DAT, '<', null),
		new OperatorObject('<=', Type.DAT, '<=', null),
		new OperatorObject('>=', Type.DAT, '>=', null)
	};

	private static final List<OperatorObject> STATIC_CHECKBOX_OPERATORS  = new List<OperatorObject> {
		new OperatorObject('Equals', null, ' = TRUE', null),
		new OperatorObject('Not Equals', null, '= FALSE', null)
	};

	private static final List<OperatorObject> STATIC_PICKLIST_OPERATORS = new List<OperatorObject> {
		new OperatorObject('contains exclusive (intersection)', Type.TEXT, '=', 'AND'),
		new OperatorObject('contains not exclusive (union)', Type.TEXT, '=', 'OR'),
		new OperatorObject('does not contain (not union)', Type.TEXT, '!=', 'AND')
	};

	private static final List<OperatorObject> STATIC_LOOKUP_OPERATORS = new List<OperatorObject> {
		new OperatorObject('Equal', Type.TEXT, '=', null),
		new OperatorObject('Not equal', Type.TEXT, '!=', null)
	};

	/* --------------------------------------------------------------------------------------------
	** Define the operatos in type - map with Key = Type, Value = FieldTypeWrapper (type, typedisplay, null, List<OperatorObject>)
	** ----------------------------------------------------------------------------------------- */   
	
	public static final Map<Schema.DisplayType, FieldTypeWrapper> mapInformation = new Map<Schema.DisplayType, FieldTypeWrapper> {
		Schema.DisplayType.address 						=> new FieldTypeWrapper(Schema.DisplayType.address		+'', 'text', null, STATIC_TEXT_OPERATORS), // Type, TypeDisplay, null, Operators
		Schema.DisplayType.base64 						=> new FieldTypeWrapper(Schema.DisplayType.base64	 	+'', 'text', null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.Boolean 						=> new FieldTypeWrapper(Schema.DisplayType.Boolean	 	+'', 'checkbox', null, STATIC_CHECKBOX_OPERATORS),
		Schema.DisplayType.Combobox						=> new FieldTypeWrapper(Schema.DisplayType.Combobox	 	+'', 'text', null, STATIC_PICKLIST_OPERATORS),
		Schema.DisplayType.Currency						=> new FieldTypeWrapper(Schema.DisplayType.Currency	 	+'', null, null, STATIC_NUMBER_OPERATORS),
		Schema.DisplayType.DataCategoryGroupReference 	=> new FieldTypeWrapper(Schema.DisplayType.DataCategoryGroupReference +'', 'lookup', null, STATIC_LOOKUP_OPERATORS),
		Schema.DisplayType.Date	 						=> new FieldTypeWrapper(Schema.DisplayType.Date	 		+'', 'date', null, STATIC_DATE_OPERATORS),
		Schema.DisplayType.DateTime	 					=> new FieldTypeWrapper(Schema.DisplayType.DateTime	 	+'', 'datetime', null, STATIC_DATE_OPERATORS),
		Schema.DisplayType.Double 						=> new FieldTypeWrapper(Schema.DisplayType.Double 		+'', null, null, STATIC_NUMBER_OPERATORS),
		Schema.DisplayType.Email 						=> new FieldTypeWrapper(Schema.DisplayType.Email 		+'', null, null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.EncryptedString 				=> new FieldTypeWrapper(Schema.DisplayType.EncryptedString+'', null, null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.ID 							=> new FieldTypeWrapper(Schema.DisplayType.ID 			+'', 'lookup', null, STATIC_LOOKUP_OPERATORS),
		Schema.DisplayType.Integer 						=> new FieldTypeWrapper(Schema.DisplayType.Integer 		+'', null, null, STATIC_NUMBER_OPERATORS),
		Schema.DisplayType.MultiPicklist 				=> new FieldTypeWrapper(Schema.DisplayType.MultiPicklist +'', 'picklist', null, STATIC_PICKLIST_OPERATORS),
		Schema.DisplayType.Percent 						=> new FieldTypeWrapper(Schema.DisplayType.Percent 		+'', null, null, STATIC_NUMBER_OPERATORS),
		Schema.DisplayType.Phone						=> new FieldTypeWrapper(Schema.DisplayType.Phone			+'', 'text', null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.Picklist 					=> new FieldTypeWrapper(Schema.DisplayType.Picklist 		+'', 'picklist', null, STATIC_PICKLIST_OPERATORS),
		Schema.DisplayType.Reference 					=> new FieldTypeWrapper(Schema.DisplayType.Reference 	+'', 'lookup', null, STATIC_LOOKUP_OPERATORS),
		Schema.DisplayType.String 						=> new FieldTypeWrapper(Schema.DisplayType.String 		+'', 'text', null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.TextArea 					=> new FieldTypeWrapper(Schema.DisplayType.TextArea 		+'', 'text', null, STATIC_TEXT_OPERATORS),
		Schema.DisplayType.Time 						=> new FieldTypeWrapper(Schema.DisplayType.Time 			+'', 'time', null, STATIC_NUMBER_OPERATORS),
		Schema.DisplayType.URL	 						=> new FieldTypeWrapper(Schema.DisplayType.URL	 		+'', 'text', null, STATIC_TEXT_OPERATORS)
	};

	/* --------------------------------------------------------------------------------------------
	** OPERATOR CLASS - gestion of operator
	** ----------------------------------------------------------------------------------------- */   

	public class OperatorObject
	{
		public String label  { get; set;} // label operator inpur
		public String value  { get; set;} // value operator
		public Type typeValue { get; set; } // Number or Text
		public String operator { get; set;} // LIKE, >, <, ...
		public String logic { get; set; } // AND or OR for list
		public String beforeValue {get; set; } // for the LIKE %
		public String afterValue {get; set; }
		public String neg {get; set; } // "NOT" Name LIKE ... 

		public OperatorObject(String label, Type typeValue, String operator, String logic)
		{
			this.label = label;
			this.value = label;
			this.typeValue = typeValue;

			this.operator = operator;
			this.logic = logic;
			this.beforeValue = '';
			this.afterValue = '';
			this.neg = '';

			if (this.logic == null) this.logic = 'AND';
		}

		public OperatorObject(String label, Type typeValue, String operator, String logic, String beforeValue, String afterValue)
		{
			this.label = label;
			this.value = label;
			this.typeValue = typeValue;

			this.operator = operator;
			this.logic = logic;
			this.beforeValue = beforeValue;
			this.afterValue = afterValue;
			this.neg = '';
		}

		public OperatorObject(String label, Type typeValue, String operator, String logic, String beforeValue, String afterValue, String neg)
		{
			this.label = label;
			this.value = label;
			this.typeValue = typeValue;

			this.operator = operator;
			this.logic = logic;
			this.beforeValue = beforeValue;
			this.afterValue = afterValue;
			this.neg = neg;
		}

		public String constructRequest(CriteriaObject criterion, String fieldNameParent)
		{
			List<String> selectedValues  = criterion.selectedValue.split(';');
			String fieldName = fieldNameParent + criterion.fieldName; // Nom du champ (Name, id, ...)
			String query = '';

			// if reference, create Account.Contact.test
			if (criterion.relationshipNames.size() > 0) {
				String beforeFieldName = '';
				for (String value : criterion.relationshipNames) {
					beforeFieldName += value + '.';
				}
				fieldName = beforeFieldName + fieldName;
			}

			// foreach to multiValue for construct operator (Name = 'a' AND LastName = '3')
			for (String value : selectedValues) {
				if (Type.NUM == typeValue) {
					query += neg + ' ' + fieldName + ' ' + operator + ' ' + beforeValue + Integer.valueOf(value) + afterValue;
				} else if (Type.TEXT == typeValue) {
					query += neg + ' ' + fieldName + ' ' + operator + ' \'' + beforeValue + value + afterValue + '\'';
				} else if (Type.DAT == typeValue) {
					query += neg + ' ' + fieldName + ' ' + operator + ' ' + value + '';
					//String dateStr = DateTime.parse(value).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
					//if (criterion.displayType == 'DATE') {
					//	dateStr = DateTime.parse(value).format('yyyy-MM-dd');
					//}
				} else {
					query += neg + ' ' + fieldName + ' ' + operator;
				}
				query += ' ' + this.logic;
			}
			query = query.removeEnd(this.logic);
			
			return '('+query+')';
		}
	}

	/* --------------------------------------------------------------------------------------------
	** VALUE WRAPPER CLASS - object for field type 
	** ----------------------------------------------------------------------------------------- */   

	public class FieldTypeWrapper
	{
		// Type (Text, pickup, number, ....)
	    public String fieldType  { get; set;}

	    // type for input in the html (text, number, date, ...)
	    public String displayType  { get; set;}

	    // with picklist 
	    public List<String> lookupObjectNames  { get; set;}
	    
	    // List 
	    public List<OperatorObject> operators  { get; set;}

		public void init(Schema.DescribeFieldResult fieldResult, String sObjectName, String fieldApiName) {
			if (this.fieldType == Schema.DisplayType.Reference + '' || this.fieldType == Schema.DisplayType.DataCategoryGroupReference + '') {
				this.lookupObjectNames = new List<String>();
				
				for(Schema.SObjectType reference : fieldResult.getReferenceTo()) {
				    this.lookupObjectNames.add(reference.getDescribe().getName());
				}
			} else if (this.fieldType == Schema.DisplayType.Id + '') {
				this.lookupObjectNames = new List<String>();
				this.lookupObjectNames.add(sObjectName);
			}
			/*	
				bug, but is good checking	
			if (this.fieldType == 'PICKLIST') {
				this.lookupObjectNames = new List<String>();
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				System.debug(ple);
				for( Schema.PicklistEntry pickListVal : ple){
					this.lookupObjectNames.add(pickListVal.getLabel() + '');
				}    
			}
				System.debug(this.lookupObjectNames);

			Map<String, Schema.SObjectType> objGlobal = Schema.getGlobalDescribe();
			
			Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
			Map<String, Schema.SObjectField> objDescribeFieldMap = objDescribe.fields.getMap();        
			
			Schema.DescribeFieldResult fieldResult = objDescribeFieldMap.get(fieldApiName).getDescribe(); 
			*/ 
		}

	    public FieldTypeWrapper(String fieldType, String displayType, List<String> lookupObjectNames, List<OperatorObject> operators)
	    {
	        this.fieldType = fieldType;
	        this.lookupObjectNames = lookupObjectNames;
	        this.operators = operators;
	        this.displayType = displayType;
	        if (displayType == null)
	        	this.displayType = 'text';
	    }

	}

	/* --------------------------------------------------------------------------------------------
	** CriteriaObject Class definition - object for criteria 
	** An instance of Criteria Object define a criterion created by the user for the current search
	** ----------------------------------------------------------------------------------------- */   
	
	public class CriteriaObject
	{
		@AuraEnabled public Integer logicNumber { get; set;}		// index to criterion in criteria List
		@AuraEnabled public Integer order { get; set; } 			// 
		@AuraEnabled public String displayType { get; set; }		//        
		@AuraEnabled public String fieldName { get; set; }			//
		@AuraEnabled public String fieldType { get; set; }			//
		@AuraEnabled public String lookupFieldQuery { get; set; }	//
		@AuraEnabled public String lookupFieldValue { get; set;}	//
		@AuraEnabled public String lookupObjectName { get; set;}	//
		@AuraEnabled public String operator { get; set; }			// Operator selected to Search / Equal, Not Equal, ...
		@AuraEnabled public String parentObjectName { get; set; }	// ObjectName to parent
		@AuraEnabled public String selectAuraId { get; set; }		// 
		@AuraEnabled public String selectedValue { get; set; }		// 
		@AuraEnabled public List<String> initValues { get; set; }	// 
		@AuraEnabled public Boolean available { get; set; }			// User have check criterion for add search
		@AuraEnabled public List<String> sObjectNames { get; set; } // recherche dans les reference. pour Account.Contact.Name, sObjectNames = [Contact], 
		@AuraEnabled public List<String> relationshipNames { get; set; } // recherche dans les reference. pour Owner.Name, sObjectNames = [Contact]

		// Find the FieldTypeWrapper in map
		public FieldTypeWrapper getFieldTypeWrapper() {
			for (Schema.DisplayType key : mapInformation.keySet()) {
				FieldTypeWrapper tmp = mapInformation.get(key);
				if (tmp.fieldType == this.fieldType) {
					return tmp;
				}
			}
			return null;
		}

		// Get Operator of Criterion
		public OperatorObject getOperator() {
			FieldTypeWrapper res = getFieldTypeWrapper();

			// is not exist FieldType
			if (res == null)
				return null;

			for (OperatorObject operator : res.operators) {
				if (operator.value == this.operator) {
					return operator;
				}
			}

			// operator is null
			return null;
		}

		// construct request SOQL
		public String getWhere(String parentFildName) {
			OperatorObject opp = getOperator();
			if (opp == null) {
				return '';
			}
			return opp.constructRequest(this, parentFildName);
		}
	}

	/* --------------------------------------------------------------------------------------------
	** VALUE WRAPPER CLASS - object for the SearchObject 
	** ----------------------------------------------------------------------------------------- */
	
	public class SearchObject
	{
	    public Integer columnFieldToSort {get; set;}    // number for the order column used to sort
	    public String sortMethod {get; set;}            // Type to sort ASC / DESC
	    public Integer limitDisplay {get; set;}         // Limite to display in table lighning
	    public Integer limitQuery {get; set;}           // limite rows max to offset
	    public Integer offset {get; set;}               // offset 
	    public String listName {get; set;}              // listname is Name of the custome Setting
	    public String logicString {get; set;}           // 1 AND 2 OR 3
	    public String parentObjectName {get; set;}      // main Object Name : exemple to Account.

	    public List<LC102_3C_CriteriaWrapper.CriteriaObject> criteria {get; set;} // list criteria to search params
	}
}