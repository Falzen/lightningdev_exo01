({
    displayContactDetails : function(component, event, helper) {
        var contactDetailsEvent = $A.get("e.c:exo01_sobjectIdForDetails");
        
        // give the event some data with a key
        contactDetailsEvent.setParams({
            'sObject': component.get('v.contact')
        });
        
        // fire the event. Any component with a <aura:handler /> on this event name will react, event this component itself if it had a <aura:handler />
        contactDetailsEvent.fire();  
        
    }
})