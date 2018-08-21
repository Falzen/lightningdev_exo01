({
	doInit: function(component, event, helper) {
		var action = component.get("c.getFilters");
		action.setParams(
			{ 
				sObjectName : component.get("v.sobjectname")
			}
		);
		action.setCallback(this, function(actionResult) {
			var filters = JSON.parse(actionResult.getReturnValue());			
			component.set("v.filters", filters);			
		});
		$A.enqueueAction(action);

	},
	selectview: function(component, event, helper) {
		var filterid = $("#filter_id").val();			
		$A.get("e.c:ltng_cal_object_filter_event").setParams({
			filterid: filterid
		}).fire();
	}

})