({
    //Set all the fiels that are allowed to be displayed
    setAllowedFields : function(component, sObjectName)
    {
        var action = component.get("c.getObjectFields");
        action.setParams({
            "sObjectName": component.get("v.sObjectName"),
            "listName" : component.get("v.listName")
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() !== null)
            {
                var allowedFields = JSON.parse(response.getReturnValue());
                console.log(allowedFields);
                component.set("v.allowedFields", allowedFields);
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                component.set("v.displayCriteria", true);
            }            
        });
        
        $A.enqueueAction(action);
    },
    
    changeLogicAndField : function (component)
    {
        // Build the searchObject and fire criteriaChangedEvent with the searchObject as a parameter
        // To build the searchObject we need : CriteriaObject list, parentObjectName and logicString
        var criteria = component.get("v.criteria");
        var parentObjectName = component.get("v.sObjectName");
        var logicString = component.get("v.logic");

        var error = "";

        logicString = logicString.replace(/([0-9]{1,3})/g, function(match, p1) {
            var i = p1 - 1;
            var tab = component.get("v.criteria");
            if (tab[i] == null || tab[i].available != true) {
                error += "[Valeur " + p1 + " invalide] ";
            }
            return " ({"+i+"}) ";
        });

        // add developer && ||
        logicString = logicString.replace(/\&\&/g, 'AND').replace(/\|\|/g, 'OR');

        // Error, format not valide
        if (error != "" && logicString != "") {
            component.set("v.messageError", "Error Logic: " + error);
            return false;
        }
        component.set("v.messageError", "...");

        // Create objet Search
        var searchObject = {
            "criteria" : criteria,
            "parentObjectName" : parentObjectName,
            "logicString" : logicString,
            "sortMethod" : "",
            "columnFieldToSort" : 0,
            "offset" : 0,
            "limitDisplay" : 25,
            "limitQuery" : 1000,
            "listName" : component.get("v.listName")
        };
        
        // send change object
        this.fireLC102_3C_ValidCriteriaChangedEvent(component, searchObject);
        return true;
    },

    //function called after the change event is fired
    fireLC102_3C_ValidCriteriaChangedEvent : function(component, searchObject)
    {
        var LC102_3C_ValidCriteriaChangedEvent =  $A.get("e.c:LC102_3C_ValidCriteriaChangedEvent");
        LC102_3C_ValidCriteriaChangedEvent.setParams({ searchObject: searchObject });
        LC102_3C_ValidCriteriaChangedEvent.fire();
    },
    
    //function called to fire the search request event  
    fireLC103_3C_SearchRequest : function(component)
    {
        var params = {
            sObjectName:  component.get("v.sObjectName"),
            listName: component.get("v.listName"),
            logic: null
        };

        var LC103_3C_SearchRequestEvent =  $A.get("e.c:LC103_3C_SearchRequestEvent");
        LC103_3C_SearchRequestEvent.setParams(params);
        LC103_3C_SearchRequestEvent.fire();  
        
    },

    parseLogicDisplay: function() {
        var test = "(1 OR 3) AND (2 OR 3)";
        creatTree(test, 0, test.length);
        
        function creatTree(arr, a, b) {
            // operator
            var opt = ['AND', 'OR'];
        
            var node = [];

            for (var i = a; i < b; i++) {
                // console.log(arr[i])
                if (opt.indexOf(arr[i]) > -1) {     // is operator
                    node.push(arr[i]);
                } else if (arr[i] == "(") {         // is ()
                    var a = findParentezClose(arr, i + 1);
                    if (a == -1) return "Erreur parenteze ')'";
                    node.push(creatTree(arr, i + 1, a))
                    i = a;
                } else {                            // is number
                    node.push(arr[i]);
                }
            }

            return node;
        }

        function findParentezClose(arr, i) {
            var compteur = 0;
            while (i < arr.length) {
                if (arr[i] == '(')
                    compteur++;
                if (arr[i] == ')') {
                    if (compteur == 0)
                        return i
                    else
                        compteur--;
                }
                i++;
            }
            return -1;
        }
    }
})