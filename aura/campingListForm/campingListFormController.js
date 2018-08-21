({    
    
    submitForm : function(component, event, helper) {
        
        var validCamping = true;

        // Name must not be blank
        var nameField = component.find("name");
        var expname = nameField.get("v.value");
        if ($A.util.isEmpty(expname)){
            validCamping = false;
            nameField.set("v.errors", [{message:"Camping Item name can't be blank."}]);
        }
        else {
            nameField.set("v.errors", null);
        }

        
        var priceField = component.find("price");
        var price = priceField.get("v.value");
        if ($A.util.isEmpty(price) || isNaN(price) || (price <= 0.0)){
            validCamping = false;
            priceField.set("v.errors", [{message:"Camping Item price can't be blank."}]);
        }
        else {
            priceField.set("v.errors", null);
        }
        
        var quantityField = component.find("quantity");
        var quantity = quantityField.get("v.value");
        if ($A.util.isEmpty(quantity) || isNaN(quantity) || (quantity <= 0)){
            validCamping = false;
            quantityField.set("v.errors", [{message:"Camping Item quantity can't be blank."}]);
        }
        else {
            quantityField.set("v.errors", null);
        }

        if(validCamping){
            
            helper.createItem(component);
            
        }
        
    },
})