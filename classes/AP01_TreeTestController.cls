public class AP01_TreeTestController {
	/*@AuraEnabled
    public static Map<String, List<sObject>> getAccounts() {
        Map<String, List<sObject>> mapTypesAccounts = new Map<String, List<sObject>>();
        List<Account> accs = new List<Account>();
        List<String> types = new List<String>();        
        Set<String> typesSet = new Set<String>();
        
        for (Account acc : [SELECT Id, name, Phone, Type FROM Account LIMIT 20]) {
            accs.add(acc);
            typesSet.add(acc.Type);
        }
        
        types.addAll(typesSet);
        
        mapTypesAccounts.put('accounts', accs);
        mapTypesAccounts.put('types', types);
        return mapTypesAccounts;
    }*/
    
    
    
    @AuraEnabled
    public static Map<String,List<Account>> getAccounts() {
        Map<String, List<Account>> mapTypesAccounts = new Map<String, List<Account>>();
        
        List<Account> accs = new List<Account>();
        // TOTO ajouter tri sur industry
        for (Account acc : [SELECT Id, name, type, industry FROM Account where type != '' AND industry != '' LIMIT 20]) {
            if(mapTypesAccounts.containsKey(acc.type)) {
                List<Account> accounts = mapTypesAccounts.get(acc.type);
                accounts.add(acc);
                mapTypesAccounts.put(acc.type, accounts);
            } else {
                system.debug(acc.type);
                mapTypesAccounts.put(acc.type, new List<Account>{acc});
            }            
            
        }
        
        system.debug(mapTypesAccounts);
        return mapTypesAccounts;
    }
    
    

}