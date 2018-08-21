({
	
	//Initializing component 
	doInit : function(component, event, helper) 
	{
		var sObjectName = component.get("v.sObjectName");
		component.set("v.criteriaText", "Hide criteria");
		component.set("v.messageError", "");
		helper.setAllowedFields(component, sObjectName);
		component.set("v.messageError", "");
	},
	
	//function that  send the request  
	sendSearchRequest : function(component, event, helper)
	{
		if (helper.changeLogicAndField(component)) {
			helper.fireLC103_3C_SearchRequest(component);
		}
	},
	
	//Display criteria input fields
	toggleCriteria : function(component, event, helper)
	{
		var displayCriteria = component.get("v.displayCriteria");
		
		if (displayCriteria)
		{
			component.set("v.displayCriteria", false);
			component.set("v.criteriaText", "Display criteria");
			$A.util.toggleClass(component.find("CriteriaDefinition"), 'slds-hide');
		}
		else
		{
			component.set("v.displayCriteria", true);
			component.set("v.criteriaText", "Hide criteria");
			$A.util.toggleClass(component.find("CriteriaDefinition"), 'slds-hide');
		}
	},

	// add Criterion
	addCriterion : function(component, event, helper)
	{
		var criteria = component.get("v.criteria");
		var logicNumber = criteria.length + 1; // id 
		// initialize criterion
		var criterion = {
			"lookupFieldQuery" : component.get("v.lookupQuery"),
			"lookupFieldValue" : component.get("v.lookupValue"),
			"fieldName" : "",
			"fieldType" : "",
			"displayType" : "",
			"parentObjectName" : component.get("v.sObjectName"),
			"operator" :"",
			"initValues" : [],
			"selectedValue" : "",
			"order" : -1,
			"selectAuraId" : ""+logicNumber,
			"logicNumber" : logicNumber,
			"lookupObjectName" : component.get("v.sObjectName"),
			"sObjectNames": [],
			"relationshipNames": [],
			"available": false // criterion is ok for send (is check)
		};
		console.log(criterion);
		criteria.push(criterion);
		component.set("v.criteria", criteria);
	},
	
	//function that handle criteria change and fire an event after the change
	handleValidCriteriaChangeEvent : function(component, event, helper)
	{
		var orldCriteria = component.get("v.criteria");
		var criteria = [];

		// delete
		if (event.getParam("deleteCriteria")) {
		    var cri = event.getParam("criterion");
		    var i = 1;

		    for (var o of orldCriteria) {
		        if (o.logicNumber != cri.logicNumber) {
		            o.logicNumber = "" + i;
		            criteria.push(o);
		            i++;
		        }
		    }

		} else {
		    criteria = orldCriteria;
		}

		component.set("v.criteria", criteria);
		helper.changeLogicAndField(component);       
	},
	
	clearCriteria : function(component, event, helper)
	{
		// delete criterion
		component.set("v.criteria", []);
	}
	
})