public with sharing class pdfDisplayController {
    
    @AuraEnabled
    public static String getTestPdf() {
        List<StaticResource> resourceList = [SELECT Name, Body, contentType 
            FROM StaticResource WHERE Name = 'pdfTest'];
        system.debug('resourceList : ' + resourceList);
        return resourceList.size() > 0 ? EncodingUtil.base64Encode(resourceList.get(0).body) : null;
    }
}