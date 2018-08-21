({
    parseUrl : function(component) {
        debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var sParameterName;
        
        for (var i = 0; i < sURLVariables.length; i++) { 
            sParameterName = sURLVariables[i].split('=');
            
            if (sParameterName[0] === 'recordId') {
                sParameterName[1] === undefined ? null : sParameterName[1];
        		component.set('v.recordId', sParameterName[1]);
                component.set('v.isRecordIdReady', true);
            }
        }
        console.log('Param name'+sParameterName[0]);
        console.log('Param value'+sParameterName[1]);
        
    }
})