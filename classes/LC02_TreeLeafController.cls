public class LC02_TreeLeafController {
    
    
    @AuraEnabled
    public static void treeLeafSelectedTest(String leafContent, String leafDisplayType) {
            system.debug(leafContent);
            system.debug(leafDisplayType);
        if (leafDisplayType == 'knowledgeArticleList') {
            system.debug('je sais ici que '+leafContent+'est un data category :');
            system.debug('SELECT Id FROM knowledgeArticleVersion WITH DATA CATEGORY ehd_Type AT '+leafContent+'__c');
        } else if(leafDisplayType == 'something') {            
        } else if(leafDisplayType == 'somethingElse') {            
        }
        
    }
}