({
    toggleNode : function(component, event, helper) {        
        if(!component.get('v.isExpanded')) {
            component.set('v.isExpanded', true);
        } else {
            component.set('v.isExpanded', false);
        }
    },
    fireLeafChoice : function(component, event, helper) {
        helper.leafChoice(component, event, helper);
       
    }
    
})