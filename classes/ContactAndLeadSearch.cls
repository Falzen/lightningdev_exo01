public class ContactAndLeadSearch {
    public static List<List< SObject>> searchContactsAndLeads(String keyword) {
        List<List< SObject>> ContactsAndLeads = [FIND :keyword IN ALL FIELDS RETURNING Contact(Name), Lead(Name)];
        return ContactsAndLeads;
    }
}