/* ------------------------------------------------------------------------------------

AVAILABLE ACTIONS:
    - initialize / reInitialize - initializes component
    - handlePicklistValueChangedEvent - assigns event to variable

------------------------------------------------------------------------------------ */

({
    initialize: function(component, event, helper) 
    {
        component.set("v.ready", true);
        if (component.get("v.sObjectName") || component.get("v.fieldAPI")) 
        {
            helper.loadValues(component);
        } 
        else 
        {
            helper.setPredefinedValues(component);
        }

        if( component.get("v.reInitialize") ) 
        {
            component.set("v.reInitialize", false);
        }
    },
    
    reInitialize: function(component, event, helper) {
        if (component.get("v.reInitialize")) 
        {
            if(component.get("v.ready")) 
            {
                helper.destroyComponent(component);
                if (component.get("v.sObjectName") || component.get("v.fieldAPI")) 
                {
                    helper.loadValues(component);
                } 
                else 
                {
                    helper.setPredefinedValues(component);
                }
            }
            component.set("v.reInitialize", false);
        }
    },
    
    destroyComponentHandler: function(component, event, helper) 
    {
        helper.destroyComponent(component);
    },
    
    handlePicklistValueChangedEvent: function(component, event) 
    {
        var fieldValue = event.getParam("fieldValue");
        component.set("v.fieldValue", fieldValue);
        component.set("v.fieldValueJSON", JSON.stringify(fieldValue));
        
        var appEvent = $A.get("e.c:LC100_3C_picklistValueChangedEventApp");
        
        appEvent.setParams({"fieldValue" : fieldValue});
        appEvent.fire();

    }
})