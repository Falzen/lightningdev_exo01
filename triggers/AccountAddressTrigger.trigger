trigger AccountAddressTrigger on Account (before insert, before update) {
	for(Account a : Trigger.New) {
        if (a.BillingPostalCode != null && !a.BillingPostalCode.equals('') && a.Match_Billing_Address__c) {
            a.ShippingPostalCode = a.BillingPostalCode;
        }
    }
}