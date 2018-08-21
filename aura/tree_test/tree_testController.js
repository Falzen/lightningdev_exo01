({
	doInit : function(component, event, helper) {
         // Prepare the action to load account record
        var action = component.get("c.getAccounts");

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var arrayOfMapKeys = [];
                var accounts = [];
                var response = response.getReturnValue();
                console.log('c.getAccounts response.getReturnValue');
                console.log(response);
                
                
                for (var key in response) {
                    arrayOfMapKeys.push(key);
                    for (var val in response[key]) {
                        accounts.push(response[key][val]);
                        
                    }
                }
                component.set('v.types', arrayOfMapKeys);
                component.set('v.accounts', accounts);
            } else {
                console.log('Problem getting accounts, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    toggleNode : function(component, event, helper) {
        var testlist = event.target.parentNode.parentNode.children;
        for (var i = 0; i < testlist.length; i++) {
            console.log(testlist[i].tagName);
            if (testlist[i].tagName == 'UL') {
                console.log('inside if ul');
                if(testlist[i].className == 'slds-is-collapsed') {
                console.log('inside if collapsed');
                    testlist[i].className = 'slds-is-expanded';
                    component.set('v.testAttr', 'slds-is-expanded');
                } else {
                console.log('inside else');
                    testlist[i].className = 'slds-is-collapsed';
                    component.set('v.testAttr', 'slds-is-collapsed');
                }
            }
        }
                
     
    }
})