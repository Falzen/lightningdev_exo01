({
	createItem : function(component, item) {
        var action = component.get("c.saveItem");
    action.setParams({
        "item": item
    });
    action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var items = component.get("v.items");
            items.push(response.getReturnValue());
            component.set("v.items", items);
            component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c',
                    'Name': '',
                    'Quantity__c': 0,
                    'Price__c': 0,
                    'Packed__c': false });
        }
    });
    $A.enqueueAction(action);
		/*var theItems = component.get("v.items");
 
        // Copy the expense to a new object
        // THIS IS A DISGUSTING, TEMPORARY HACK
        var newItem = JSON.parse(JSON.stringify(item));
 
        theItems.push(newItem); 
        component.set("v.items", theItems);
       console.log('theItems helper==',theItems);*/
    
	},
    
    validateItemForm: function(component) {

    // Simplistic error checking
    var validExpense = true;

    // Name must not be blank
    var fld = component.find("ciName");
    var fldVal = fld.get("v.value");
    if ($A.util.isEmpty(fldVal)){
        validExpense = false;
        fld.set("v.errors", [{message:"Name can't be blank."}]);
    }
    else {
        fld.set("v.errors", null);
    }

    // Amount must be set, must be a positive number
    var quantFld = component.find("ciQuantity");
    var quantFldVal = quantFld.get("v.value");
    if ($A.util.isEmpty(quantFldVal) || isNaN(quantFldVal) || (quantFldVal <= 0.0)){
        validExpense = false;
        quantFld.set("v.errors", [{message:"Enter qunatity."}]);
    }
    else {
        // If the amount looks good, unset any errors...
        quantFld.set("v.errors", null);
    }
        
        // Amount must be set, must be a positive number
    var priceFld = component.find("ciPrice");
    var priceFldVal = priceFld.get("v.value");
    if ($A.util.isEmpty(priceFldVal) || isNaN(priceFldVal) || (priceFldVal <= 0.0)){
        validExpense = false;
        priceFld.set("v.errors", [{message:"Enter price."}]);
    }
    else {
        // If the amount looks good, unset any errors...
        priceFld.set("v.errors", null);
    }
    
    return(validExpense);
}
})