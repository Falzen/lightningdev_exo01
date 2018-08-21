({
	prev : function(component, event, helper) {
		component.set('v.isNextActive', true);
		
		var currentPageIndex = component.get('v.currentPageIndex');
		var prevBtn = component.find('prev-btn');
		if(1*(currentPageIndex) == 0) {
			component.set('v.isPrevActive', false);
			return;
		}

		currentPageIndex = 1*(currentPageIndex) - 1;
		component.set('v.currentPageIndex', currentPageIndex);
		if(1*(currentPageIndex) == 0) {
			component.set('v.isPrevActive', false);
		} else {
			component.set('v.isPrevActive', true);
		}
		helper.sendNewPagination(component, event, helper);
		
	},
	
	next : function(component, event, helper) {
		component.set('v.isPrevActive', true);

		var currentPageIndex = component.get('v.currentPageIndex');
		currentPageIndex = 1*(currentPageIndex) + 1;
		component.set('v.currentPageIndex', currentPageIndex);
		helper.sendNewPagination(component, event, helper);
	},

	disableNextBtn: function(component, event, helper) {
		component.set('v.isNextActive', false);		
	}
})