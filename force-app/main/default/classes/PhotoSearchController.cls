public with sharing class PhotoSearchController {

    @AuraEnabled(Cacheable=true)
    public static SearchResult getPhotos(SearchProperties searchProperties) {
        
        String key, whereClause = '';
        if (String.isNotBlank(searchProperties.searchKey)) {
            whereClause = 'WHERE Title__c LIKE  \'%' + searchProperties.searchKey + '%\'';
        }
        Integer pageSize = searchProperties.pageSize;
        Integer offset = (searchProperties.pageNumber - 1) * pageSize;
        
        SearchResult result = new SearchResult();
        result.pageSize = searchProperties.pageSize;
        result.pageNumber = searchProperties.pageNumber;

        result.totalItemCount = Database.countQuery(
            'SELECT COUNT() FROM Photo__c ' + whereClause
        );

        result.records = Database.query(
            'SELECT Id, Title_Trimmed__c, Thumbnail_Url__c, External_Id__c FROM Photo__c ' + whereClause + ' WITH SECURITY_ENFORCED ORDER BY External_Id__c LIMIT :pageSize OFFSET :offset'
        );
        return result;
    }

    @AuraEnabled
    public static void sendEmail(String toAddress, String body) {
        
        try{
            Messaging.reserveSingleEmailCapacity(1);
            messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();        
        
            mail.setToAddresses(new List<String>{toAddress});
            mail.setReplyTo(UserInfo.getUserEmail());
            mail.setSenderDisplayName(UserInfo.getUserName());
            mail.setSubject('Photo Gallery Search result - ' + Datetime.now());
            mail.setHtmlBody(body);
            Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    public with sharing class SearchProperties {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public Integer pageSize { get; set; }
        @AuraEnabled
        public Integer pageNumber { get; set; }
    }
}
