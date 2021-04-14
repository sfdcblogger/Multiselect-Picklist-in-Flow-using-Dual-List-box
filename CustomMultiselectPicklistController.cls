public with sharing class CustomMultiselectPicklistController {
    public CustomMultiselectPicklistController() {

    }

    public class MultiSelectPicklistOptionsNotFoundException extends Exception {}
    
    @AuraEnabled
    public static List<SObject> fetchMultiselectPicklistOptions(String objectName){
        System.debug('objectName = '+objectName);
        List<SObject> optionsList = new List<SObject>();
        try{
			optionsList = DatabaseQueryManager.fetchRecords(objectName, '', '');
            if(optionsList.size() == 0){
                throw new MultiSelectPicklistOptionsNotFoundException();
            }
        }catch(Exception ex){
            System.debug('Exception ='+ex.getMessage()+' : '+ex.getLineNumber());
        }
        System.debug('optionsList size = '+optionsList.size());
        System.debug('optionsList = '+optionsList); 
        return optionsList;
    }
}