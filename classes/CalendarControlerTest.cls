@isTest 
private class CalendarControlerTest{
    static testMethod void testAllMethods() {
        CalendarController.getUsers();
        String user_id = CalendarController.getUserId();
       	System.assertEquals( user_id, UserInfo.getUserId() );
       	
       	
        Boolean result = CalendarController.createNewEvent( '2016-01-01 00:00:00','2016-01-01 01:00:00',user_id,null,null,'test event' );
				
		System.assertEquals( [SELECT Id FROM Event].size(), 1 );

		Event e = new Event();
       	e.StartDateTime = DateTime.valueOf( '2016-01-01 00:00:00' );
       	e.EndDateTime   = DateTime.valueOf( '2016-01-01 01:00:00' );
       	e.OwnerId = user_id;
       	e.subject = 'test';
       	INSERT e;

		String sResult = CalendarController.getEvents( DateTime.valueOf('2015-01-01 00:00:00'), DateTime.valueOf('2017-01-01 01:00:00'),user_id );
		


    }
}