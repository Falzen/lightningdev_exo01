({

    
	doInit : function(component, event, helper) {
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.accounts", response.getReturnValue());
                //just to be damn sure
                setTimeout(function() {
                    // one <button> inside StockTicker, one below
                    // only targets the one below (1found)
               		var inputField = document.getElementsByTagName("button");
                    console.log(inputField);
                },2000);
            }
        });
     	$A.enqueueAction(action);
        
        
	},
    
    handleClick: function(component, event, helper) {
        

    }
    
    
})