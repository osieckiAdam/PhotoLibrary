public with sharing class SearchResult {
    @AuraEnabled
    public List<Object> records { get; set; }
    @AuraEnabled
    public Integer pageNumber { get; set; }
    @AuraEnabled
    public Integer pageSize { get; set; }
    @AuraEnabled
    public Integer totalItemCount { get; set; }

}
