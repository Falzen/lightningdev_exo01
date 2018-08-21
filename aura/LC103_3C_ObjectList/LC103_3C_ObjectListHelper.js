({
    //function called to set fields columns that we get in apex class 
    setColumns : function(component, sObjectName)
    {
        var self = this;
        return new Promise(function(res, rej) {
            var action = component.get("c.getColumns");
            
            action.setParams({
                "sObjectName" : sObjectName || component.get("v.sObjectName"),
                "listName" : component.get("v.listName"),
                "selectAllTheFields" : component.get("v.selectAllTheFields"),
                "searchObject" : component.get("v.searchObject")
            });
            
            action.setCallback(self, function(actionResult) {
                var columns = actionResult.getReturnValue();
                console.log(columns);
                // sort column with order
                columns.sort(function(a, b) { return a.order - b.order; });
                component.set("v.columns", columns);
                res();
            });
            
            $A.enqueueAction(action);
            self.setObjectListParent(component);
        })
    },

    setObjectListParent: function(component) {
        var action = component.get("c.getChilden");
        
        action.setParams({
            "sObjectName" : component.get("v.sObjectName"),
            "listName" : component.get("v.listName"),
            "selectAllTheFields" : component.get("v.selectAllTheFields")
        });
        
        action.setCallback(this, function(actionResult) {
            try {
                var childens = actionResult.getReturnValue();
                console.log("setObjectListParent", actionResult.getReturnValue(), childens);
                component.set('v.childrens', childens);
            } catch (e) {
                console.log('Error getChilden: ', e);
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    //function called after the search is launched
    startSearch : function(component, logic)
    {
        component.set('v.loading', true);
        var sObj = component.get("v.searchObject");

        // add sort in search object
        if (sObj == null) {
            var searchObject = {};
            sObj = searchObject;
        }
        sObj.sortMethod = component.get("v.sortMethod");
        sObj.columnFieldToSort = component.get("v.columnToSort");
        sObj.offset = component.get("v.offset");
        sObj.limitDisplay = component.get("v.limitDisplay");

        var childen = component.get("v.children");
        if (childen) {
            sObj.parentObjectName = childen.objectName+'-'+childen.relationTo+'-'+childen.fieldName+'-'+childen.relationshipName;        
        }


        var action = component.get("c.executeSearch");
        action.setParams({
            "serializedColumns" : JSON.stringify(component.get("v.columns")),
            "sObjectName" : component.get("v.sObjectName"),
            "serializedSearchObject" : JSON.stringify(sObj),
            "logic": logic
        });
        
        var obj = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.loading', false);
            console.log(actionResult)
            if (actionResult.getReturnValue() == null) {
                return false;
            }
            try {
                var objet = JSON.parse(actionResult.getReturnValue());
                console.log(objet);
                component.set("v.countRows", objet.count);
                component.set("v.results", objet.results);
                obj.actualPagination(component);
            } catch (e) {
                console.log(e)
            }
        });
        
        $A.enqueueAction(action);
    },
    actualPagination: function(component) {
        var count = component.get("v.countRows");
        var numberParPage = component.get("v.limitDisplay");
        var limiteOffset = component.get("v.limitQuery");
        var offset = component.get("v.offset");

        if (offset + numberParPage > limiteOffset || offset + numberParPage > count) {
            component.set('v.next', true);
        } else {
            component.set('v.next', false);            
        }

        if (offset + numberParPage < numberParPage + 1) {
            component.set('v.prev', true);
        } else {
            component.set('v.prev', false);            
        }

        var page = Math.ceil((component.get("v.offset") + 1) / numberParPage);
        if (page < 0) page = 1;
        component.set('v.page', page);
        component.set('v.pageMax', Math.ceil(count / numberParPage))
    },

    // close dropdown
    closeDropdown: function(notDelete) {
        var els = document.querySelectorAll('.dropdown');

        // si on as aucun dropdown
        if (!els) return null;

        // pour tout les request fermer le dropdown
        for (var i = 0; i < els.length; i++) {
            els[i].classList.remove("slds-is-open");
        }

        document.removeEventListener('click', this.closeDropdown);
    }
    
})