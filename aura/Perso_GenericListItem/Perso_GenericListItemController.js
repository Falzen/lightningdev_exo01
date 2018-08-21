({
    doInit : function(component, event, helper) {
        var labelValueList = helper.transformObjectIntoLabelValuePair(component);
        component.set('v.objectListToDisplay', labelValueList);
        
    },
    goToDetails : function(component, event, helper) {
        helper.goToDetails(component, event, helper);
    }
})