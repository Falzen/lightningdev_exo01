public class StringArrayTest {

    public static List<String> generateStringArray(Integer numberOfStrings) {
        List<String> listOfStrings = new List<String>();
        
        for (Integer i=0; i<numberOfStrings; i++) {
            String temp = 'Test ' + i;
            listOfStrings.add(temp);
        }
        System.debug(listOfStrings);
		return listOfStrings;
    }
    
    
}