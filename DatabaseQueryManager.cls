public class DatabaseQueryManager {
        
    public static List<sObject> fetchRecords(String objectName, String filter, String orderBy) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> fieldSetObjMap = describeSObjectResultObj.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fieldSetObjMap.values();
        
        String queryString= 'SELECT ';
        
        for( Schema.SObjectField s : fldObjMapValues ) {
            //To check the current user's field-level read permission before querying for this field:
            if (s.getDescribe().isAccessible()) {
                String fieldName = s.getDescribe().getName();
                queryString+= fieldName + ', ';
            }
        }
        
        queryString = queryString.removeEnd(', ');
        
        queryString += ' FROM '+ ObjectName;
        if(String.isNotBlank(filter)){
            queryString += ' WHERE ' + filter;
        }
        if(String.isNotBlank(orderBy)){
            queryString += ' Order By ' + orderBy;
        }
        System.debug(LoggingLevel.DEBUG, 'soql query string =======' + queryString);
        return (List<sObject>) Database.query(queryString);
    }
    
    public static String quoteString (String str){
        if(String.isNotEmpty(str)){
            return '\'' + str + '\'';
        }
        return str;
    }
    
    
    @InvocableMethod(label='Fetch SObjectName')
    public static List<string> fetchObjectName(List<string> recordIdStrings){
        // object Ids to return
        List<string> objectNames = new List<string>();
        // get record name
        Id recordId = Id.valueOf(recordIdStrings[0]);        
        String objectName = recordId.getSObjectType().getDescribe().getName();
        // add object name to list
        objectNames.add(recordId.getSobjectType().getDescribe().getName());
        // return
        return objectNames;
    }
}