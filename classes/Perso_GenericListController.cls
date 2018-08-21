public class Perso_GenericListController {


	@AuraEnabled
	public static List<Object> getSobjects(String sObjectName, List<String> wantedFields, String orderByFieldName, String orderByDirection, String nbRecordsPerPage, String pageIndex) {


		System.Debug('Perso_GenericListController - getSobjects - sObjectName : ' + sObjectName);
		System.Debug('Perso_GenericListController - getSobjects - wantedFields : ' + wantedFields);
		System.Debug('Perso_GenericListController - getSobjects - orderByFieldName : ' + orderByFieldName);
		System.Debug('Perso_GenericListController - getSobjects - orderByDirection : ' + orderByDirection);
		System.Debug('Perso_GenericListController - getSobjects - nbRecordsPerPage : ' + nbRecordsPerPage);
		System.Debug('Perso_GenericListController - getSobjects - pageIndex : ' + pageIndex);



		String query = 'SELECT ';
		for(Integer i=0; i<wantedFields.size(); i++) {
			query += wantedFields[i];
			query += ', ';
		}
		query = query.removeEnd(', ');

		query += ' FROM ';
		query += sObjectName;

		if (orderByFieldName != null && orderByFieldName != '') {
			if(orderByDirection == null || orderByDirection == '') {
				orderByDirection= 'ASC';
			}
			query += ' ORDER BY '+orderByFieldName + ' ' + orderByDirection;

		}
		query += ' LIMIT ' + nbRecordsPerPage;
		query += ' OFFSET ' + Integer.valueOf(pageIndex) * Integer.valueOf(nbRecordsPerPage);
		system.Debug('Perso_GenericListController - getSobjects - query : ' + query);
		List<sObject> result = Database.query(query);

		system.Debug('Perso_GenericListController - getSobjects - result : ' + result);


		return result;
    }// end getSobjects


	@AuraEnabled
	public static RecordDetailsWrapper getRecordInfoForDetails(Id recordId) {
        RecordDetailsWrapper details = new RecordDetailsWrapper();
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        String recordTypeDevName = '';
        

        return details; 
    }


    public class RecordDetailsWrapper {

	@AuraEnabled
    public String sObjectName{get; set;}

	@AuraEnabled
    public String recordTypeDevName{get; set;} 
    }

}