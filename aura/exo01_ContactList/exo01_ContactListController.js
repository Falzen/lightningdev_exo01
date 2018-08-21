({
    goGetContacts : function(component, event, helper) {
        helper.resetContactDetails(component);
        helper.showSpinner(component);

        var accountId = event.getParam("sobjectId");
        var getContactsAction = component.get('c.getContactsByAccountId');
        getContactsAction.setParams({
            'accId': accountId
        });
        getContactsAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log(result);
                component.set('v.contacts', result);
        		helper.hideSpinner(component);
            }
            else if (state === "ERROR") {
        		helper.hideSpinner(component);
                var errors = response.getError();
                if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
                else {
        		helper.hideSpinner(component);
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(getContactsAction);
    },
    displaySobjectDetails: function(component, event, helper) {
        
        helper.showSpinner(component);
		var sObject = event.getParam('sObject');
        if(sObject != null && sObject != undefined) {
            component.set('v.sObjectForDetails', sObject);
            component.set('v.showDetails', true);
        		helper.hideSpinner(component);
        }
    }
})