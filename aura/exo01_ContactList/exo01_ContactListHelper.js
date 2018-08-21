({
	resetContactDetails : function(component) {
		component.set('v.sObjectForDetails', null);
		component.set('v.showDetails', false);
	},
    showSpinner: function(component) {
        var spinnerElement = component.find('spinner');
        $A.util.removeClass(spinnerElement, 'slds-hide');
    },
    hideSpinner: function(component) {
        var spinnerElement = component.find('spinner');
        $A.util.addClass(spinnerElement, 'slds-hide');
        
    }
})