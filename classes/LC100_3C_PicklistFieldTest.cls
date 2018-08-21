@isTest
public class LC100_3C_PicklistFieldTest
{
    @isTest
    public static void getPicklistValuesTest()
    {
        List<LC100_3C_PicklistField.ValueWrapper> results = (List<LC100_3C_PicklistField.ValueWrapper>) JSON.deserialize(LC100_3C_PicklistField.getPicklistValues('Case', 'Status'),
                                                                                                                         List<LC100_3C_PicklistField.ValueWrapper>.class);
        System.assert(results.size() > 0);
    }
}