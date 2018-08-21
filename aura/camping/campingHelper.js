({
	createItem : function(component, item) {
		
            var newItem = JSON.parse(JSON.stringify(expense));
	        var items = component.get("v.items");
            items.push(newExpense);
	        component.set("v.items", items);
	}
})