({
    packItem: function(component, event, helper) {
        
        // on choppe TOUT le component
        var a = component.get("v.item",true);
        
        //on met son attribut à true
        a.Packed__c = true;
        
        //on le réinjecte dans la page (brutal)
        component.set("v.item",a);
        
        // désactiver le button (récup puis set son attr)
        var btnClicked = event.getSource();
        btnClicked.set("v.disabled",true); 
    }
    
    
})