({
	doInit: function(component, event, helper) {
		var fields = component.get("v.sfieldnames");
		fields = fields.split(",");
		component.set( "v.fields", fields );

		var labels = component.get("v.sfieldlabels");
		labels = labels.split(",");
		if( labels.length == fields.length ){
			component.set( "v.labels", labels );	
		}
		else{
			component.set( "v.labels", fields );		
		}		
	},
	loadRecords: function(component, event, helper) {
		var filterid = event.getParam("filterid");
		
		var action = component.get("c.getRecords");
		var params = { 
				sObjectName : component.get("v.sobjectname"),
			    sFieldNames: component.get("v.sfieldnames"),
			    sFilterId: filterid,
    			iPage: component.get("v.ipage"),
    			iPageSize: component.get("v.ipagesize")
		};
		action.setParams(params);
		action.setCallback(this, function(actionResult) {
			component.set("v.records",actionResult.getReturnValue() );
		});
		$A.enqueueAction(action);
	}
})