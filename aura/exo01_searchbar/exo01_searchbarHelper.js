({	
    filter: function(component, event, helper) {
		var userInput = component.get('v.userInput');
		console.log('userinput', userInput);
        var userInputEvent = $A.get("e.c:exo01_fromSearchbarEvent");
        
        userInputEvent.setParams({
            'userInput': userInput
        });
        
        userInputEvent.fire(); 
    }
})