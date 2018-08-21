({
	doInit : function(component, event, helper) {
        var action = component.get("c.getTestPdf");
        console.log('doinit');
        action.setCallback(this, function(response) {
            var state = response.getState();
                console.log(state);
            if (state === "SUCCESS") {
                console.log('action c.getTestPdf SUCCESS');
                component.set("v.pdf-data", response.getReturnValue());
            }
            else if (state === "ERROR") {
                console.log('action c.getTestPdf ERROR');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})