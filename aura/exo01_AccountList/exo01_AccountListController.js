({
    doInit: function (component, event, helper) {
        var isWithPagination = component.get('v.withPagination');
        if (isWithPagination) {
            helper.refreshListFromPagination(component, event, helper);
        } else {
            helper.getAllAccounts(component, event, helper);
        }
    },

    filterAccountList: function (component, event, helper) {
        // get parameter included in the event received
        var userInput = event.getParam('userInput');

        // always check...
        if (userInput == null || userInput == undefined) {
            // get all of them, stored since the doInit and set in view
            var allAccounts = component.get('v.allAccounts'); // could be merged with l.60 but clearer to read
            component.set('v.accountsToDisplay', allAccounts);
            return;
        }

        // filter results
        var filteredList = [];
        var allItems = component.get('v.allAccounts');// could be merged with l.54 but clearer to read

        // fill up with concording items and set in view
        for (var i = 0; i < allItems.length; i++) {
            if (allItems[i].Name.toLowerCase().includes(userInput.toLowerCase())) {
                filteredList.push(allItems[i]);
            }
        }
        component.set('v.accountsToDisplay', filteredList);
    },
    refreshListFromPagination: function (component, event, helper) {
        var listName = component.get('v.listName');
        if (event.getParam('listName') == listName) {
            helper.refreshListFromPagination(component, event, helper);
        }
    }

})