public class parentId_recursive_test {
    public class accountOutput {
        public account record {get; set;}
        public account[] children {get; set;} 
    }
    
    public map<id, accountOutput> output {get; set;}
    
    public void buildOutput(string accountid){
        this.output = new map<id, accountOutput>();
        for(account a : [select id, name, parentId from account order by parentId nulls first]){
            if(this.output.get(a.id) == null){
                accountOutput tmp = new accountOutput();
                tmp.record = a;
                tmp.children = new account[]{};
                    }
            if(a.parentId != null){
                if(this.output.get(a.parentId) != null){
                    this.output.get(a.parentId).children.add(a);
                }
            }
        }
        system.debug('parentId_recursive_test - buildOutput - this.output : '+ this.output);
    }
    
    public string value(){
        string accId = '0010Y00001QJ4TDQA1'; // grandparent
        buildOutput(accId);
        return JSON.serialize(this.output);
    }
}