({
    doInit: function(component, event, helper) {
        /* = = = = = évolution = = = = = */
        var contacts = component.get('v.account.Contacts');
        if(contacts != undefined) {
            var contactsNb = contacts.length;
            component.set('v.contactsNumber', contactsNb);
        }
        /* = = = = = = = = = = = = = = = = */
    },

    selectAccount : function(component, event, helper) {
        // get existing event from application
        var selectedSobjectId = $A.get("e.c:exo01_selectedSobjectId");
        
        // give the event some data with a key
        selectedSobjectId.setParams({
            'sobjectId': component.get('v.account.Id')
        });
        
        // fire the event. Any component with a <aura:handler /> on this event name will react, event this component itself if it had a <aura:handler />
        selectedSobjectId.fire();        
        
    },
    setAccountIsSelected: function(component, event, helper) {
        /* = = = = = évolution = = = = = */
        
        // get selected account from event
        var selectedId = event.getParam('sobjectId');
        
        // get this account
        var domLi = component.find('oneListItem').getElement();
        
        // check if they are the same account, and class or not
        if(selectedId == component.get('v.account.Id')) {
            $A.util.addClass(domLi, 'isCurrentItem');
        } else {
            $A.util.removeClass(domLi, 'isCurrentItem');
        }
        /* = = = = = = = = = = = = = = = = */
    }
})