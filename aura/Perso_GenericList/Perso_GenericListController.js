({
	doInit : function(component, event, helper) {
		
		helper.getSobjects(component, event, helper);
		
	},
	nextPage: function(component, event, helper) {
		var pageIndex = component.get('v.pageIndex');
		if (!component.get('v.hasNoMoreRecords')) {
			pageIndex ++;
			component.set('v.pageIndex', pageIndex);
			helper.getSobjects(component, event, helper);	
		}

	},
	previousPage: function(component, event, helper) {
		var pageIndex = component.get('v.pageIndex');
		if (pageIndex > 0) {
			pageIndex --;
			component.set('v.pageIndex', pageIndex);
			helper.getSobjects(component, event, helper);
		}

	}
})