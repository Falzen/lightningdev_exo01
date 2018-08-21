({
    transformObjectIntoLabelValuePair : function(component) {
        var item = component.get('v.item');
        var headerList = component.get('v.headerList');
        var result = [];
        for(var i=0; i<headerList.length; i++) {
            var tempObject = {};
            var currentLabel = headerList[i].apiName;
            tempObject.label = currentLabel;
            tempObject.value = item[currentLabel];
            result.push(tempObject);
        }
        return result;
    },
    goToDetails : function(component, event, helper) {
        var recordId = component.get('v.item').Id;
        var goToDetailsEvent = $A.get("e.force:navigateToURL");
        goToDetailsEvent.setParams({
            'url': 'details?recordId=' + recordId
        }); 
        goToDetailsEvent.fire();
    }
})