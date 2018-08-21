global class LC102_3C_DesignObjectNamePickList extends VisualEditor.DynamicPickList
{
    // The default value is selected if no values are selected in the app builder
    global override VisualEditor.DataRow getDefaultValue()
    {        
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Case', 'Case');
        return defaultValue;
    }
    
    // Return the list of all the standard and custom objects of the organisation
    global override VisualEditor.DynamicPickListRows getValues()
    {
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        
        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
        {
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            VisualEditor.DataRow value = new VisualEditor.DataRow(objResult.getLabel(), objResult.getName());
            myValues.addRow(value);
        }
        
        return myValues;
    }
}