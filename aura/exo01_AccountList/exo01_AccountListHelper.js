({
    getAllAccounts: function (component, event, helper) {
        // method name of Apex controller
        var getAccountsAction = component.get('c.getAccounts');
        // deal with the callback 
        getAccountsAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // the return value itself
                var result = response.getReturnValue();
                // always check if not null, not undefined...
                if (result != null && result != undefined) {
                    // reference for futur filter trims
                    component.set('v.allAccounts', result);
                    // the filtered list to display (in doInit : display all)
                    component.set('v.accountsToDisplay', result);
                }
            }
            /* * * * * * * * * * * * * * * * * * * * * * * * * * */
            /* should always AT LEAST deal with errors like so : */
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
            /* * * * * * * * * * * * * * * * * * * * * * * * * * */
        });
        // send request to server, will be dealt with when server available (enqueue)
        $A.enqueueAction(getAccountsAction);
    },
    refreshListFromPagination: function (component, event, helper) {

        var pageIndex = event.getParam('pageIndex') ? event.getParam('pageIndex') : 0;        
        console.log('pageIndex : ', pageIndex);

        var getPaginatedAccountsAction = component.get('c.getAccountsWithPagination');

        getPaginatedAccountsAction.setParams({
            'pageIndex': pageIndex
        });

        getPaginatedAccountsAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null && result != undefined) {

                    if (result.length == 11) {
                        result.length = 10;
                    }
                    else {
                        $A.get('e.c:exo01_isLastPageEvent').fire();
                    }

                    component.set('v.allAccounts', result);
                    component.set('v.accountsToDisplay', result);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                }
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(getPaginatedAccountsAction);
    }
})