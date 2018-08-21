public class LC02_DataCategoryTreeController {
    
    
    
    
    /*
@param List<String> whichObjects     list of sObject names (must be sObjects associated with Data Categories)
ex: new List<String>(){'KnowledgeArticleVersion'});
*/  
    @AuraEnabled
    public static String getDescribeDataCategoryGroupStructureResults(List<String> whichObjects){
        List<DescribeDataCategoryGroupResult> describeCategoryResult;
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
        try {
            //Making the call to the describeDataCategoryGroups to get the list of category groups associated
            describeCategoryResult = Schema.describeDataCategoryGroups(whichObjects);
            
            //Creating a list of pair objects to use as a parameter for the describe call
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            
            //Looping throught the first describe result to create the list of pairs for the second describe call
            for(DescribeDataCategoryGroupResult singleResult : describeCategoryResult){
                DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
                p.setSobject(singleResult.getSobject());
                p.setDataCategoryGroupName(singleResult.getName());
                pairs.add(p);
            }
            
            //describeDataCategoryGroupStructures()
            describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);                
            
            //Getting data from the result
            for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult) {
                //Get name of the associated Sobject
                singleResult.getSobject();                
                //Get the name of the data category group
                singleResult.getName();                
                //Get the name of the data category group
                singleResult.getLabel();                
                //Get the description of the data category group
                singleResult.getDescription();
                
                //Get the top level categories
                DataCategory [] toplevelCategories = singleResult.getTopCategories();                
                //Recursively get all the categories
                List<DataCategory> allCategories = 
                    getAllCategories(toplevelCategories);                        
                
                for(DataCategory category : allCategories) {
                    //Get the name of the category
                    category.getName();                    
                    //Get the label of the category
                    category.getLabel();
                    
                    //Get the list of sub categories in the category
                    DataCategory [] childCategories = 
                        category.getChildCategories();
                }
            }
        } catch (Exception e){
            //TODO trow real error            
        }
        
        //TODO virer categories des labels des variables
        
        
        
        
        return JSON.serializePretty(describeCategoryStructureResult);        
    }
    
    private static DataCategory[] getAllCategories(DataCategory [] categories){
        if(categories.isEmpty()){
            return new DataCategory[]{};
                } else {
                    DataCategory [] categoriesClone = categories.clone();
                    DataCategory category = categoriesClone[0];
                    DataCategory[] allCategories = new DataCategory[]{category};
                        categoriesClone.remove(0);
                    categoriesClone.addAll(category.getChildCategories());
                    allCategories.addAll(getAllCategories(categoriesClone));
                    return allCategories;
                }
    }
    
    
    private static LC02_TreeDataWrapper[] castDataCategoriesIntoWrapper(List<DescribeDataCategoryGroupStructureResult> catStructRes) {
        
        List<LC02_TreeDataWrapper> wrapper = new List<LC02_TreeDataWrapper>();
        system.debug(catStructRes);
        
        return wrapper;
    }
    
    
    public class LC02_TreeDataWrapper {
        public String label{set;get;}
        public String name{set;get;}
        public String description{set;get;}
        // TODO add whatever field is wanted
        public List<LC02_TreeDataWrapper> nestedWrapper{set;get;}
        
    }
    
    
    public class JSONCategory{
        public String label{set;get;}
        public String name{set;get;}
        public List<TopLevelCategory> topCategories{set;get;}
    }
    
    public class TopLevelCategory{
        public List<ChildLevelCategory> childCategories{set;get;}
    }
    
    public class ChildLevelCategory{
        public List<ChildLevelCategory> childCategories{set;get;}
        public String label{set;get;}
        public String name{set;get;}
    }
    
    
    
}