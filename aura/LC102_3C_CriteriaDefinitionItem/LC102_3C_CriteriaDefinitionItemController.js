({
	//Component initialization
	doInit : function(component, event, helper) {
		helper.addAllowedFields(component, null, null, 0);
	},

	onFieldSelection0 : function(component, event, helper) { helper.onFieldSelection(component, event, helper, 0); },
	onFieldSelection1 : function(component, event, helper) { helper.onFieldSelection(component, event, helper, 1); },
	onFieldSelection2 : function(component, event, helper) { helper.onFieldSelection(component, event, helper, 2); },
	onFieldSelection3 : function(component, event, helper) { helper.onFieldSelection(component, event, helper, 3); },
	
	onOperatorSelection : function(component, event, helper)
	{
		var operator = event.getSource().get("v.value");
		var criterion = component.get("v.criterion");
		
		component.set("v.operator", operator);        
		
		// First check if the operator selected with a correct value
		// Fill the value in the object Criterion and fire the event to the primary component
		// With this event we can process the value changes with an other component
		
		if (operator !== null && operator !== undefined && operator !== "" && operator !== "-- please select an operator --")
		{
			if (criterion.displayType === 'checkbox'
				&& (criterion.selectedValue === undefined || criterion.selectedValue === null || criterion.selectedValue === ''))
			{
				criterion.selectedValue = 'false';
			}
		} else {
			// initialisation operator
			component.set("v.criterion.available", false);
			component.set("v.available", false);
			operator = "";
		}

		criterion.operator = operator;                   
		component.set("v.criterion", criterion);

		// Send LC102_3C_ValidCriteriaChangeEvent
		helper.fireLC102_3C_ValidCriteriaChangeEvent(component);
	},
	
	onCheck: function(component, event, helper)
	{
		var checkBoxValue = component.find("checkbox").get("v.value");
		var value = (checkBoxValue) ? "true" : "false";
		
		var criterion = component.get("v.criterion");
		
		if (value !== null && value !== undefined && value !== "")
		{
			criterion.selectedValue = value;            
			component.set("v.criterion", criterion);
			
			// Send LC102_3C_ValidCriteriaChangeEvent
			helper.fireLC102_3C_ValidCriteriaChangeEvent(component);
		}        
	},
	
	//When the text type field change
	onTextChange : function(component, event, helper)
	{
		var criterion = component.get("v.criterion");
		var value = component.get("v.value");
				
		//check the field type text, picklist or autocomplete and get the appropriate value
		// valueWrapper et valueWrappers => picklist ou Autocomplete
		if (value !== null && value !== undefined && value !== "")
		{
			criterion.selectedValue = value;            
			component.set("v.criterion", criterion);
			
			// Send LC102_3C_ValidCriteriaChangeEvent
			helper.fireLC102_3C_ValidCriteriaChangeEvent(component);           
		}        
	},
	
	//To do when the picklist type field change    
	handlePicklistChange : function(component, event, helper)
	{
		var criterion = component.get("v.criterion");
		var valueWrappers = component.get("v.valueWrappers");
		
		if (valueWrappers !== null && valueWrappers !== undefined && valueWrappers.length > 0) 
		{
			var val = "";

			for (var i = 0; i < valueWrappers.length; i++) {
				val += valueWrappers[i].value+";";
			}

			criterion.selectedValue = val;                       
			component.set("v.criterion", criterion);
			
			// Send LC102_3C_ValidCriteriaChangeEvent
			helper.fireLC102_3C_ValidCriteriaChangeEvent(component);          
		}        
	},
	
	//to do to handle autocomplete change
	
	handleAutocompleteChange : function(component, event, helper)
	{
		var criterion = component.get("v.criterion");
		var valueWrapper = component.get("v.valueWrapper");
		
		if (valueWrapper !== null && valueWrapper !== undefined) {

			criterion.lookupObjectName = valueWrapper.id;
			criterion.selectedValue = valueWrapper.value;            
			component.set("v.criterion", criterion);
			
			// Send LC102_3C_ValidCriteriaChangeEvent
			helper.fireLC102_3C_ValidCriteriaChangeEvent(component);            
		}        
	},
	
	// Active disable criteria
	onAvailable : function(component, event, helper)
	{
		// get value available ligne
		var checkBoxValue = component.get("v.criterion.available");
		var operator = component.get("v.criterion.operator");

		component.set("v.messageError", "...");
		if (checkBoxValue == false
			&& operator !== null
			&& operator !== undefined
			&& operator !== ""
			&& operator !== "-- please select an operator --")
		{
			component.set("v.criterion.available", true);
			// component.set("v.checked", "true");
		} else {
			component.set("v.criterion.available", false);
			// component.set("v.checked", "false");
		}
	},

	// delete this criterion
	delete : function(component, event, helper) {
		helper.fireLC102_3C_ValidCriteriaChangeEventDelete(component);
	}
})