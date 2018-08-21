@isTest
public class TestVerifyDate {
    

        static Date date1 = Date.today();
        static Date date2 = date1.addDays(15);
        static Date date3 = date1.addDays(300);
    	
		static Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		static Date endOfDate1 = Date.newInstance(date1.year(), date1.month(), totalDays);
    
    @isTest
    static void checkDatesTest() {   
        
        System.assertEquals(date2, VerifyDate.CheckDates(date1, date2));   
        
        System.assertNotEquals(date1, VerifyDate.CheckDates(date1, date3));  
        System.assertEquals(endOfDate1, VerifyDate.CheckDates(date1, date3));       
    }
    
    
    
    
    
}