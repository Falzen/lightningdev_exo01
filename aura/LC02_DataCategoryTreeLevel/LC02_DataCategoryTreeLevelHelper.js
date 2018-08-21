({
    leafChoice : function(component, event, helper) {
        
        
        var action = component.get('c.treeLeafSelectedTest');
        
        console.log('inside leafChoice helper');
        var nameTest = component.get('v.item')['name'];
        console.log('nameTest = ' + nameTest);
        
        
        action.setParams({
            leafContent : nameTest,
            leafDisplayType : 'knowledgeArticleList'
        });
        
        
        
        action.setCallback(this, function(response) {
            console.log('inside leafChoice setCallback');
            var state = response.getState();
            if (state === "SUCCESS") {
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
        
        
        
        
        $A.enqueueAction(action);
        
        
    }
})