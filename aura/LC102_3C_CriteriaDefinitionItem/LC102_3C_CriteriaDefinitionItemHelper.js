({
	// select filed
	onFieldSelection : function(component, event, helper, id)
	{
		// event.target.id
		var value = event.getSource().get("v.value");
		var list = component.get('v.criterion.sObjectNames');

		if (value.substr(0, 4) == "ref:") {
			// add reference in list
			var args = value.split(':');
			list = list.slice(0, id + 1);
			list.push(args[1]);
			component.set('v.criterion.sObjectNames', list);

			helper.addAllowedFields(component, args[1], args[2], id + 1);
			return null;
		}
		
		// add ObjectName to List
		var list = component.get('v.criterion.sObjectNames');
		list = list.slice(0, id + 1);
		component.set('v.criterion.sObjectNames', list);

		// add RelationshipName
		list = component.get('v.criterion.relationshipNames');
		list = list.slice(0, id);
		component.set('v.criterion.relationshipNames', list);

		// Object account
		console.log(list[list.length - 1], list);
		component.set('v.criterion.lookupObjectName', list[list.length - 1]);

		helper.setFieldInformation(component, value);
	},

	addAllowedFields : function(component, objectName, relationshipName, index)
	{
		var obj = this;
		var allowedFields = component.get("v.allowedFields");
		var objectDefault = component.get("v.sObjectName");

		if (objectName && objectName != objectDefault) {
			this.setAllowedFields(component, objectName, function(allowedFields) {
				obj.addAllowedFields2(component, objectName, relationshipName, index, allowedFields)
			});
		} else {
			obj.addAllowedFields2(component, objectDefault, relationshipName, index, allowedFields)
		}
	},

	addAllowedFields2 : function(component, objectName, relationshipName, index, allowedFields)
	{
		// add ObjectName to List
		var list = component.get('v.criterion.sObjectNames');
		list = list.slice(0, index);
		list.push(objectName);
		console.log(list);
		component.set('v.criterion.sObjectNames', list);

		// add RelationshipName
		list = component.get('v.criterion.relationshipNames');
		list = list.slice(0, index - 1);
		if (index > 0)
			list.push(relationshipName);
		console.log(list);
		component.set('v.criterion.relationshipNames', list);

		// add Field
		var opts = [];
		var criterion = component.get("v.criterion");
		
		opts.push({class: "optionClass", label: "-- please select a field --", value: "-- please select a field --"});
		for (var i = 0; i < allowedFields.length;i++)
		{
			// if end fieldChoice, not reference
			if (index > 2 && allowedFields[i].isReference)
				continue;

			// if is reference add the >
			if (allowedFields[i].isReference)
				opts.push({class: "optionClass", label: allowedFields[i].label + ' ►', value: 'ref:'+allowedFields[i].sObjectName+':'+(allowedFields[i].relationshipName || allowedFields[i].sObjectName )});
			else
				opts.push({class: "optionClass", label: allowedFields[i].label, value: allowedFields[i].apiName});
		}
		console.log("criterionSelect-"+index)
		component.find("criterionSelect" + index).set("v.options", opts);
	},


	//Set all the fiels that are allowed to be displayed
	setAllowedFields : function(component, sObjectName, callback)
	{
	    var action = component.get("c.getObjectFields");
	    action.setParams({
	        "sObjectName": sObjectName,
	        "listName" : component.get("v.listName")
	    });
	    
	    action.setCallback(this, function(response) {  
	        var state = response.getState();
	        if (state === "SUCCESS" && response.getReturnValue() !== null)
	        {
	        	callback(JSON.parse(response.getReturnValue()));
	        }
	    });
	    
	    $A.enqueueAction(action);
	},

	//function called to set field information
	setFieldInformation : function(component, fieldApiName)
	{
		var criterion = component.get("v.criterion");
		var action = component.get("c.getFieldType");
		
		// get ObjectName
		var list = component.get('v.criterion.sObjectNames');
		var objectName = list[list.length - 1] || criterion.parentObjectName;

		//It takes sObjectName and fieldApiName as parameters 
		action.setParams({
			"sObjectName": objectName,
			"fieldApiName" : fieldApiName
		});
		
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS" && response.getReturnValue() !== null)
			{
				//get information to Object select
				var fieldTypeWrapper = JSON.parse(response.getReturnValue());
				criterion.fieldType = fieldTypeWrapper.fieldType;
				criterion.displayType = fieldTypeWrapper.displayType;
				criterion.fieldName = fieldApiName;
				component.set("v.lookupObjectNames", fieldTypeWrapper.lookupObjectNames);
				
				var opts = [];
				
				opts.push({class: "optionClass", label: "-- please select an operator --", value: "-- please select an operator --"});
				for (var i = 0; i < fieldTypeWrapper.operators.length; i++)
				{
					opts.push({class: "optionClass", label: fieldTypeWrapper.operators[i].label, value: fieldTypeWrapper.operators[i].value});
				}
				
				component.find("operator").set("v.options", opts);
				$A.util.removeClass(component.find("operator"), "slds-hide");
				
				
				component.set("v.criterion", criterion);
			}
		});
		
		$A.enqueueAction(action);
	},

	//function called to fire  ValidCriteriaChange Event
	fireLC102_3C_ValidCriteriaChangeEvent : function(component)
	{
		var criterion = component.get("v.criterion");
		
		if (criterion.operator !== null && criterion.operator !== undefined && criterion.operator !== "" && criterion.operator !== "-- please select an operator --" 
			&& criterion.selectedValue !== null && criterion.selectedValue !== undefined && criterion.selectedValue !== '')
		{
			// Send LC102_3C_ValidCriteriaChangeEvent
			var LC102_3C_ValidCriteriaChangeEvent = component.getEvent("LC102_3C_ValidCriteriaChangeEvent");
			LC102_3C_ValidCriteriaChangeEvent.setParams({ validatedChange: true });
			LC102_3C_ValidCriteriaChangeEvent.fire();
		}
	},

	//function called to fire  ValidCriteriaChange Event
	fireLC102_3C_ValidCriteriaChangeEventDelete : function(component)
	{
		var criterion = component.get("v.criterion");

		// Send LC102_3C_ValidCriteriaChangeEvent
		var LC102_3C_ValidCriteriaChangeEvent = component.getEvent("LC102_3C_ValidCriteriaChangeEvent");
		LC102_3C_ValidCriteriaChangeEvent.setParams({
			validatedChange: true,
			deleteCriteria: true,
			criterion: criterion
		});
		
		LC102_3C_ValidCriteriaChangeEvent.fire();
	}

})