({
	//Function called after criteria change
	handleCriteriaChange : function(component, event, helper) 
	{
		var searchObject = event.getParam("searchObject");
		
		if (searchObject.listName === component.get("v.listName")){
			searchObject.limitDisplay = component.get("v.limitDisplay");
			searchObject.limitQuery = component.get("v.limitQuery");
			component.set("v.searchObject", searchObject);
		}
	},
	
	//Component initialization
	doInit : function(component, event, helper)
	{
		helper.setColumns(component);
	},
	
	//Function called after the search request is sent 
	handleSearchRequest : function(component, event, helper)
	{ 
		if (component.get("v.sObjectName") === event.getParam("sObjectName") && 
			component.get("v.listName") === event.getParam("listName"))
		{  
			component.set("v.offset", 0);
			helper.actualPagination(component);
			helper.startSearch(component, event.getParam("logic"));
		}
	},

	// sort by Column
	sortBycolumn : function(component, event, helper) {
		var fieldApiName = event.target.id;
		var rowActuel = component.get("v.columnToSort");
		var sortMethod = component.get("v.sortMethod");

		// Finf order row in colomns
		var rows = component.get("v.columns");
		for (var row of rows) {
			// column is sortable
			if (row.fieldApiName == fieldApiName && row.isSortable) {

				// togle sort methode ASC or DESC
				if (rowActuel && rowActuel == row.order) {
					if (sortMethod == 'ASC') {
						component.set("v.columnToSort", row.order);
						component.set("v.sortMethod", "DESC");
					} else {
						component.set("v.columnToSort", -1);
						component.set("v.sortMethod", "ASC");
					}
				} else {
					component.set("v.columnToSort", row.order);
					component.set("v.sortMethod", "ASC");
				}
				var search = component.get("v.searchObject");

				component.set("v.offset", 0);
				helper.actualPagination(component);
				helper.startSearch(component, "");
				return ;
			}
		}
	},
	Next : function(component, event, helper) {
		var count = component.get("v.countRows");
		var numberParPage = component.get("v.limitDisplay");
		var limiteOffset = component.get("v.limitQuery");
		var offset = component.get("v.offset");

		component.set("v.offset", offset + numberParPage);

		helper.actualPagination(component);
		helper.startSearch(component, "");
	},
	Previous : function(component, event, helper) {
		var count = component.get("v.countRows");
		var numberParPage = component.get("v.limitDisplay");
		var limiteOffset = component.get("v.limitQuery");
		var offset = component.get("v.offset");

		component.set("v.offset", offset - numberParPage);

		helper.actualPagination(component);
		helper.startSearch(component, "");
	},

	// changer d'objet pour le parrent
	selectChild: function(component, event, helper) {
		var id = event.target.dataset.id;
		var childens = component.get('v.childrens');

		console.log(event.target, id);
		// Aucun
		if (!childens || id === null)
			return false;
		
		id = parseInt(id);
		if (id < -1 || id > childens.length) {
			return false;
		}

		// rajouter le cas -1 remettre pas default
		if (id == -1) {
			helper.setColumns(component).then(function() {
				component.set('v.children', null);
				helper.startSearch(component, "");
			});
			return null;
		}

		var objectName = childens[id].objectName;

		helper.setColumns(component, objectName).then(function() {
			component.set('v.children', childens[id]);
			helper.startSearch(component, "");
		});
	},

	selectAllChange: function(component, event, helper) {
		// component.set("v.selectAll", !component.get("v.selectAll"));
		var results = component.get("v.results");
		var checkBoxValue = component.get("v.selectAll");

		for (var i = 0; i < results.length;i++) {
			results[i].active = checkBoxValue;
		}
		
		component.set("v.results", results);
	},
	openDropdown: function(component, event, helper) {
		if (!event.currentTarget.parentNode.classList.contains("slds-is-open")) {
			helper.closeDropdown();
			event.currentTarget.parentNode.classList.add("slds-is-open");
			document.addEventListener('click', helper.closeDropdown); // add Event dropdown
		} else {
			helper.closeDropdown();
			// event.currentTarget.parentNode.classList.toggle("slds-is-open");
		}
		event.stopPropagation();
	},

	canselCloseDropdown: function(component, event) {
		event.stopPropagation();
	},

	toggleSelectColumn: function(component, event, helper) {
		var order = event.currentTarget.dataset.id;
		var columns = component.get('v.columns');
		var existIsDisplay = false;

		for (var i = columns.length - 1; i >= 0 && !existIsDisplay; i--) {
			if (columns[i].isDisplay)
				existIsDisplay = true;
		}

		
		for (var i = columns.length - 1; i >= 0; i--) {

			if (order == 'all') {
				columns[i].isDisplay = !existIsDisplay;
			}

			if (columns[i].order == order) {
				columns[i].isDisplay = !columns[i].isDisplay;
			}

		}
		component.set('v.columns', columns);
		helper.startSearch(component, "");
	}
})