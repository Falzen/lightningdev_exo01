({
	hasMinorContact: function (component, event, helper) {
        var contacts = component.get('v.account.Contacts');
		for (var i = 0; i < contacts.length; i++) {
			console.log('contacts[i] : ', contacts[i]);
			if (contacts[i].Birthdate != undefined) {
				console.log('contacts[i].Birthdate : ', contacts[i].Birthdate);
				console.log('contacts[i].Birthdate type of: ', typeof contacts[i].Birthdate);
var daaate = new Date(contacts[i].Birthdate);
console.log('date : ', daaate);
			}
		}
	}
})