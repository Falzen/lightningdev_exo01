public with sharing class StandardSetController{

  @auraEnabled
  public static List<sObject> getRecords(    
    String sObjectName, String sFieldNames, String sFilterId, 
    Integer iPage, Integer iPageSize
  ){
    List<sObject> resultSet;
    String baseQuery = 'SELECT ' + sFieldNames + ' FROM ' + sObjectName + ' LIMIT 1000';
    ApexPages.StandardSetController SetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
    //SetController.setPageSize(5);
    //SetController.setpageNumber(iPage);
    SetController.setFilterId(sFilterId);
    resultSet = SetController.getRecords();
    return resultSet;
  }

  @auraEnabled
  public static String getFilters( String sObjectName ){
    String baseQuery = 'SELECT Id, Name FROM ' + sObjectName;
    ApexPages.StandardSetController SetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
    
    List<SelectOptionWrapper> options = new List<SelectOptionWrapper>();
    for(SelectOption so:SetController.getListViewOptions()){
      options.add( new SelectOptionWrapper(so) );
    }
    return JSON.serialize( options );
  }


  public static List<String> getFiltersSimple( String sObjectName ){
    List<String> ret = new List<String>();
    String baseQuery = 'SELECT Id, Name FROM ' + sObjectName;
    ApexPages.StandardSetController SetController = new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));
    
    for(SelectOption so:SetController.getListViewOptions()){
      ret.add( so.getValue() );
    }
    return ret;
  }

  private class SelectOptionWrapper{    
    String label{get;set;}
    String value{get;set;}
    SelectOptionWrapper( SelectOption so ){
      this.label = so.getLabel();
      this.value = so.getValue();
    }
  }
}