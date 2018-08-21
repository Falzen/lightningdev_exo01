public class CalendarController {
	@auraEnabled
	public static List<User> getUsers(){
		return [SELECT Id, Name,LastName, FirstName FROM User WHERE isActive=:true LIMIT 50000];
	}

	@auraEnabled
	public static String getUserId(){
		return UserInfo.getUserId();
	}


	@auraEnabled
	public static Boolean createNewEvent( String start_time, String end_time, String user_id, String what_id, String sobjectName, String title ){
		Event e = new Event();
		e.StartDateTime = DateTime.valueOf(start_time);
		e.EndDateTime = DateTime.valueOf(end_time);
		e.subject = title;
		e.OwnerId = user_id;
		if( sobjectName == 'Lead' || sobjectName == 'Contact' ){
			e.whoId = what_id;	
		}
		else{
			e.whatId = what_id;	
		}		
		INSERT e;
		return e.Id != null;
	}

	@auraEnabled
	public static String getEvents( DateTime start_time, DateTime end_time, String user_id ){
        Date dStartDate = Date.valueof(start_time);
        Date dEndDate   = Date.valueof(end_time);

        
	    List<String> listClassName = new LIST<String>();
	    for( Integer i = 1; i< 100; i++ ){
	      listClassName.add( 'UserEvent-'+i );
	    }
	    LIST<CustomEvent> listEvent = new LIST<CustomEvent>();
	    for( Event a:[
	      SELECT StartDateTime, EndDateTime, Owner.Name, Subject 
	      FROM Event
	      WHERE
	        ( 
	          // User selector
	          OwnerId =: user_id 
	        ) AND
	        (
	          (
	            // scope contains event
	            StartDateTime >=: dStartDate AND
	            EndDateTime <=: dEndDate
	          ) OR
	          (
	            // scope partically contains event
	            (
	              StartDateTime >=: dStartDate AND
	              StartDateTime <=: dEndDate
	            ) OR
	            (
	              EndDateTime >=: dStartDate AND
	              EndDateTime <=: dEndDate
	            )
	          ) OR
	          (
	            // event contains scope
	            StartDateTime <=: dStartDate AND
	            EndDateTime >=: dEndDate
	          )
	        )
	      LIMIT 50000  
	      ] 
	    ){
	      CustomEvent tmp = new CustomEvent(a);      
	      listEvent.add( tmp );
	    }
	    return JSON.serialize(listEvent).replace('end_time_x', 'end');		
	}


	public class CustomEvent{
		public String title {get;set;}
		public String start {get;set;}
		public String end_time_x {get;set;}
		public String id {get;set;}
		public String className {get;set;}

		public CustomEvent( Event e ){
			this.title = e.subject;
			this.start = String.valueof( e.StartDateTime );
			this.end_time_x = String.valueof( e.EndDateTime );
			this.id = e.Id;
		}
	}

}