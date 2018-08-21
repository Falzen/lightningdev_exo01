({
    doInit: function(component, event, helper){
        
        // sets userId
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set('v.user_id', userId);
        $('#calendar').fullCalendar(
            {
                defaultView: 'agendaWeek',
                allDaySlot: false,
                selectable: true,
                selectHelper: true,
                // when selecting a period of time
                select: function(start, end) {
                    
                    var title = prompt("Please enter subject of event:");
                    var eventData;
                    if (title) {
                        // create the sObject
                        var action = component.get("c.createNewEvent");
                        var params = { 
                            start_time : start.format("YYYY-MM-DD HH:mm:ss"),
                            end_time   : end.format("YYYY-MM-DD HH:mm:ss"),
                            user_id    : component.get("v.user_id"),
                            what_id    : component.get("v.recordId"),
                            sobjectName    : component.get("v.sObjectName"),
                            title      : title		
                        };
                        action.setParams(params);
                        
                        action.setCallback(this, function(actionResult) {	
                            debugger;
                            if( actionResult.getReturnValue() ){
                                $('#calendar').fullCalendar( 'refetchEvents' );
                                console.log("save successful");
                            }
                            else{
                                var errors = actionResult.getError();
                                if (errors) {
                                    if (errors[0] && errors[0].message) {
                                        console.log("Error message: " + 
                                                    errors[0].message);
                                    }
                                } else {
                                    console.log("Unknown error");
                                }
                                alert( "Save failed for some reason." );
                            }
                        });
                        
                        $A.run(function(){
                            $A.enqueueAction(action);						
                        });
                        
                    }
                    $('#calendar').fullCalendar('unselect');
                },
                
                events: function(start, end, timezone, callback) {
                    debugger;
                    var user_id = component.get("v.user_id");	    		
                    var action = component.get("c.getEvents");
                    action.setParams(
                        { 
                            start_time : start,
                            end_time   : end,
                            user_id    : user_id		
                        }
                    );
                    
                    action.setCallback(this, function(actionResult) {
                    debugger;
                        callback(JSON.parse(actionResult.getReturnValue()));
                    });
                    $A.enqueueAction(action);				
                },
                // when click on already exicsting period
                eventClick: function(calEvent, jsEvent, view) {
                    var navToSObjEvt = $A.get("e.force:navigateToSObject");
                    navToSObjEvt.setParams({
                        recordId: calEvent.id,
                        slideDevName: "detail"
                    }); 
                    navToSObjEvt.fire();
                }
            }
        );
    },
    loadCalendar: function(component, event, helper) {
        component.set("v.user_id", event.getParam("calendarUserId"));
        $('#calendar').fullCalendar( 'refetchEvents' );
    },
    recordSelected: function(component, event, helper) {		
        component.set( "v.recordId", event.getParam("recordid") );
        component.set( "v.sObjectName", event.getParam("sobjectname") );		
    }
    
    
})