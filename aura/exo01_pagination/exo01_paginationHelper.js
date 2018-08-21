({
	sendNewPagination: function (component, event, helper) {
		var paginationEvent = $A.get("e.c:exo01_paginationEvent");
		paginationEvent.setParams({
			'listName': component.get('v.listName'),
			'pageIndex': component.get('v.currentPageIndex')
		});
		paginationEvent.fire();
	}
})