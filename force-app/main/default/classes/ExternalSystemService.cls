/**
 * Service for accessing and consuming data stored in external sytem
 */
public with sharing class ExternalSystemService {

    //TODO Create Global Settings and store endpoint there
    private static String photosEndpoint = 'https://jsonplaceholder.typicode.com/photos';
    private static ExternalSystemService instance;

    public static ExternalSystemService getInstance() {
        if(instance == NULL) {
            instance = new ExternalSystemService();
        }
        return instance;
    }

    public String fetchDataFromAPI() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(photosEndpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response.getBody();
    }

    /**
     * Return all photos stored in external service as Map, where key is External Id, and value
     * is Photo__c record
     */
    public Map<String, Photo__c> getIncomingPhotosByExternalId() {

        String fetchedData = ExternalSystemService.getInstance().fetchDataFromAPI();

        Map<String, Photo__c> fetchedPhotosByExternalId = new Map<String, Photo__c>();
        for(Object record : (List <Object>) JSON.deserializeUntyped(fetchedData)) {
            Map<String, Object> recordAsMap = (Map<String, Object>)(record);
            String fetchedRecordId = String.valueOf(recordAsMap.get('id'));
            if(fetchedRecordId != null && fetchedPhotosByExternalId.get(fetchedRecordId) == null) {
                fetchedPhotosByExternalId.put(fetchedRecordId, PhotoObjectUtil.parseExternalRecordToPhoto(recordAsMap));
            }
        }
        return fetchedPhotosByExternalId;
    }
}
