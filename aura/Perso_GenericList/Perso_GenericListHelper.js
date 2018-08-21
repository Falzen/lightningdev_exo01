({
	getSobjects: function (component, event, helper) {
		var wantedFields = [];
		var wantedFieldsApiNames = [];
		var wantedSobjectName = component.get('v.sObjectName');
		if (component.get('v.headerList').length == 0) {
			var fieldsForAccount = [{ 'apiName': 'Id', 'label': 'Salesforce Id' }, { 'apiName': 'Name', 'label': 'Nom' }, { 'apiName': 'CreatedDate', 'label': 'Date de création' }];
			var fieldsForContact = [{ 'apiName': 'Id', 'label': 'Salesforce Id' }, { 'apiName': 'FirstName', 'label': 'Prénom' }, { 'apiName': 'LastName', 'label': 'Nom de famille' }];


			switch (wantedSobjectName) {
				case 'Account':
					wantedFields = fieldsForAccount;
					break;
				case 'Contact':
					wantedFields = fieldsForContact;
					break;

				default:
					wantedFields = [{ 'apiName': 'Id', 'label': 'Id' }, { 'apiName': 'Name', 'label': 'Nom' }, { 'apiName': 'CreatedDate', 'label': 'Date de création' }];
					break;
			}
			component.set('v.headerList', wantedFields);
		}
		else {
			wantedFields = component.get('v.headerList');
		}


		for (var i = 0; i < wantedFields.length; i++) {
			wantedFieldsApiNames.push(wantedFields[i].apiName);
		}
		var settings = {
			'sObjectName': wantedSobjectName,
			'wantedFields': wantedFieldsApiNames,
			'orderByFieldName': '',
			'orderByDirection': component.get('v.orderByDirection'),
			'pageIndex': '' + component.get('v.pageIndex')
		};



		var getSobjectListAction = component.get('c.getSobjects');

		getSobjectListAction.setParams({
			'sObjectName': wantedSobjectName,
			'wantedFields': wantedFieldsApiNames,
			'orderByFieldName': '',
			'orderByDirection': component.get('v.orderByDirection'),
			'nbRecordsPerPage': ''+component.get('v.nbRecordsPerPage'),
			'pageIndex': ''+component.get('v.pageIndex')
		});
  
		getSobjectListAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {

				var result = response.getReturnValue();
				if (result != null && result != undefined) {
					console.log('result : ', result);
					if (result.length < component.get('v.nbRecordsPerPage')){
						component.set('v.hasNoMoreRecords', true);
					} else {
						component.set('v.hasNoMoreRecords', false);
					}
					component.set('v.objectList', result);
				}
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				}
				else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getSobjectListAction);
	}
})