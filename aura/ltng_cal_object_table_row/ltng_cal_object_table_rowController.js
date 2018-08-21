({
	doInit: function(component, event, helper) {
		var record = component.get( "v.record" );
		var fields = component.get( "v.fields" );
		var values = new Array();
		for( var field of fields ){
			values.push( record[field] );
		}
		component.set( "v.rowvalue", values );
	},
	recordSelected: function(component, event, helper) {
		var recordid = $('input[name=record_select]:checked').val();
		var sobjectname = component.get("v.sobjectname");		
		var params = {
			recordid: recordid,
			sobjectname: sobjectname
		};

		$A.get("e.c:ltng_cal_object_record_selected").setParams(params).fire();
	}
})