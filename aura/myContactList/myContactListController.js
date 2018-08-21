({
	myAction : function(component, event, helper) {
        
        // sets up a call to a server-side method
		var action = component.get("c.getContacts");
        
        // sets up what to do after (should test if SUCCESS)
        action.setCallback(this, function(data) {
        	component.set("v.contacts", data.getReturnValue());
        });
        
        // starts the call
        $A.enqueueAction(action);

	}
})