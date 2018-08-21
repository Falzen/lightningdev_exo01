({
    filterOnEnterKey: function (component, event, helper) {
        var whichKey = event.getParams().keyCode;
        switch (whichKey) {
            case 13:
            console.log('enter');
            helper.filter(component, event, helper);
            break;
        }
    },
    filter: function (component, event, helper) {
        var userInput = component.get('v.userInput');
        console.log('userinput', userInput);
        helper.filter(component, event, helper);
    }
})