/* ------------------------------------------------------------------------------------

LOAD VALUES:
    - loadValues

------------------------------------------------------------------------------------ */

//don't remove the comment below it allows the use of jQuery variable without any error during the lint process
/*eslint-env jquery, dependentUtils */
({

    /* ------------------------------------------------------------------------------------------------ */
    /* -------------------------------- AJAX LOADED VALUES METHODS ------------------------------------ */
    /* ------------------------------------------------------------------------------------------------ */

    loadValues: function(component) {
        component.set("v.loading", true);
        component.set("v.values", null);

        var action = component.get("c.getPicklistValues");
        action.setParams({
            "sObjectName": component.get("v.sObjectName"),
            "fieldAPI": component.get("v.fieldAPI")
        });

        action.setCallback(this, function(response) {
            var result = JSON.parse(response.getReturnValue());
            if(result !== null && result.ctrlFieldDescribe !== undefined){
                var ctrlFieldDescribe = result.ctrlFieldDescribe;
                var depFieldDescribe = result.depFieldDescribe;
                var controlFieldValue = result.controlFieldValue;
                var availableValues = [];
                /*
                 * call the getDependentValues from the dependentPicklistUtils js file in the static ressource
                 * it returns all values dependent to the control value passed as parameter
                */
                /* globals dependentUtils */
                availableValues = dependentUtils.getDependentValues(ctrlFieldDescribe, depFieldDescribe, controlFieldValue);

                component.set("v.values", availableValues);
            } else {
                component.set("v.values", result);
            }

            this.createSelect(component);
            component.set("v.loading", false);
        });

        $A.enqueueAction(action);
    },



    /* ------------------------------------------------------------------------------------------------ */
    /* -------------------------------- PREDEFINED VALUES METHODS ------------------------------------- */
    /* ------------------------------------------------------------------------------------------------ */

    setPredefinedValues: function(component) {
        var valuesJSON = component.get("v.valuesJSON");

        //if values are defined then display them, else show loading
        if (valuesJSON) {
            component.set("v.values", JSON.parse(valuesJSON));

            this.createSelect(component);
            component.set("v.loading", false);
        } else {
            //values are not yet passed by parent component, still loading
            component.set("v.loading", true);
        }
    },



    /* ------------------------------------------------------------------------------------------------ */
    /* --------------------------------------- HELPER METHODS ----------------------------------------- */
    /* ------------------------------------------------------------------------------------------------ */

    createSelect: function(component){
        var helper = this;
        var suggestions = component.get("v.values");
        var picklistSelectBox = component.find('picklistSelectBox').getElement();

        var preselectedValues = this.getPreselectedValues(component, suggestions);
        component.set("v.preselectedValues", preselectedValues);

        //workaround to salesforce issue with <aura:iterate ../>
        jQuery(picklistSelectBox).empty();
        jQuery.each(preselectedValues, function(index, preselectVal) {
            var option = $('<option></option>').attr("value", preselectVal.value).attr("selected", "selected").text(preselectVal.label);
            jQuery(picklistSelectBox).append(option);
        });

        //data rework required to match entry data for select2
        var selectData = [];
        jQuery.each(suggestions, function(index, suggestion) {
            selectData.push({
                id: suggestion.value,
                text: suggestion.label
            });
        });


        jQuery.fn.select2.amd.require(["select2/data/array", "select2/utils"], function(ArrayData, Utils) {
            function CustomData($element, options) {
                CustomData.__super__.constructor.call(this, $element, options);
            }
            Utils.Extend(CustomData, ArrayData);

            //override for standard select2 query, allows for lazy loading of preloaded values
            CustomData.prototype.query = function(params, callback) {
                var pageSize = 50;

                if (!params.page) {
                    params.page = 1;
                }

                var items;
                if (params.term) {
                    items = [];
                    jQuery.each(selectData, function(index, item) {
                        if (item.text.toUpperCase().indexOf(params.term.trim().toUpperCase()) != -1) {
                            items.push(item);
                        }
                    });
                } else {
                    items = selectData;
                }

                var data = {
                    results: items.slice((params.page - 1) * pageSize, params.page * pageSize),
                    pagination: {
                        more: params.page * pageSize < items.length
                    }
                };

                callback(data);
            };
  
            //init select2
            jQuery(picklistSelectBox).select2({
                ajax: {},
                dataAdapter: CustomData
            });

            //register event for propagating selected values to the controller and component
            jQuery(picklistSelectBox).on("change", function(event) {
                if (component.isValid()) {
                    helper.emitChangeEvent(component, event);
                }
            });

            //register event for focusing on select2 when item is selected and popup is closed
            jQuery(picklistSelectBox).on("select2:closing", function(event) {
                jQuery(picklistSelectBox).select2('focus');
            });

            //fire change event if there are preselected values
            if (preselectedValues.length > 0) {
                jQuery(picklistSelectBox).trigger('change');
            }
        });

        component.set("v.select2Initialized", true);
    },

    getPreselectedValues: function(component, suggestions) {
        var resultList = [];
        var fieldValueJSON = component.get("v.fieldValueJSON");

        if (fieldValueJSON != undefined && fieldValueJSON !== '') {
            var preselectedValues = JSON.parse(fieldValueJSON);

            if (preselectedValues && preselectedValues.constructor === Array && preselectedValues.length > 0) {
                var preselectedValuesPopulated = [];

                jQuery.each(preselectedValues, function(pvIndex, pvItem) {
                    //if preselected value is passed without label get it from suggestions
                    if (typeof pvItem == "object"
                        && (!pvItem.label || pvItem.label == "")) {
                        jQuery.each(suggestions, function(sIndex, sItem) {
                            if (pvItem.value === sItem.value) {
                                pvItem.label = sItem.label;
                            }
                        });
                    }

                    //if preselected value is not an object, but just a key
                    if (typeof pvItem == "string") {
                        jQuery.each(suggestions, function(sIndex, sItem) {
                            if (pvItem === sItem.value) {
                                preselectedValuesPopulated.push({
                                    value: pvItem,
                                    label: sItem.label
                                })
                            }
                        });
                    }
                });

                resultList = preselectedValuesPopulated.length > 0? preselectedValuesPopulated : preselectedValues;
            } else if (component.get("v.preselectAll")) {
                resultList = suggestions;
            }
        }

        return resultList;
    },

    emitChangeEvent: function(component, event) {
        var selectedPicklistValues = jQuery(event.target).val();
        var suggestions = component.get("v.values");

        var selectedPicklistValuesArray = [];
        if (selectedPicklistValues && !Array.isArray(selectedPicklistValues)) {
            selectedPicklistValuesArray = [selectedPicklistValues];
        } else {
            selectedPicklistValuesArray = selectedPicklistValues;
        }

        var picklistValueChangeEventNotification = [];
        if(selectedPicklistValuesArray) {
            jQuery.each(selectedPicklistValuesArray, function(indexPicklistElement, picklistElement) {
                jQuery.each(suggestions, function(indexSuggestion, suggestionElement) {
                    if (picklistElement === suggestionElement.value) {
                        picklistValueChangeEventNotification.push({value: suggestionElement.value, label: suggestionElement.label});
                        return false;
                    } else {
                        return true;
                    }
                });
            });
        }

        var picklistValueChangedEvent = component.getEvent("picklistValueChangedEvent");
        picklistValueChangedEvent.setParams({ fieldValue: picklistValueChangeEventNotification });
        picklistValueChangedEvent.fire();
    },

    destroyComponent: function(component) {
        component.set("v.preselectedValues", []);

        if (component.get("v.select2Initialized")) {
            var picklistSelectBox = component.find('picklistSelectBox').getElement();
            if (picklistSelectBox) {
                var $picklistSelectBox = jQuery(picklistSelectBox);

                //clear select element - options might be there if select is reinitialized
                $picklistSelectBox.empty();

                //if select2 was initialized delete it on component destruction and remove attached events
                $picklistSelectBox.off("change");
                $picklistSelectBox.off("select2:closing");
                $picklistSelectBox.select2("destroy");
            }

            component.set("v.select2Initialized", false);
        }
    }

})