({
	doInit: function(component, event, helper){
		// query list of users


		var action = component.get("c.getUsers");
		action.setCallback(this, function(actionResult) {
	    	component.set( "v.user_list", actionResult.getReturnValue() );
			var action = component.get("c.getUserId");
			action.setCallback(this, function(actionResult) {
				var user_id = actionResult.getReturnValue();
				component.set( "v.user_id", user_id );
				$A.get("e.c:CalendarUserId").setParams({
					calendarUserId: user_id
				}).fire();
			});
			$A.enqueueAction(action);


	    });
	    $A.enqueueAction(action);		






	},

	selectUser: function(component, event, helper) {
		var userId = $("#user_id").val();		
		$A.get("e.c:CalendarUserId").setParams({
			calendarUserId: userId
		}).fire();
	}
})