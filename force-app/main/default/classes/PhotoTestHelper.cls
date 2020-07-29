/**
 * Helper class for tests related with Photo object
 */
@IsTest
public with sharing class PhotoTestHelper {

    public static final String TEST_ID = '1';
    public static final String TEST_ALBUM_ID = '1';
    public static final String TEST_THUMBNAIL_URL = 'https://via.placeholder.com/150/1fe46f';
    public static final String TEST_TITLE = 'laboriosam odit nam necessitatibus et illum dolores reiciendis';
    public static final String TEST_URL = 'https://via.placeholder.com/600/1fe46f';
    private static final String EXAMPLE_RESPONSE_BODY = 
    '[{' +
        '"albumId": 1,' +
        '"id": 1,' +
        '"title": "accusamus beatae ad facilis cum similique qui sunt",' +
        '"url": "https://via.placeholder.com/600/92c952",' +
        '"thumbnailUrl": "https://via.placeholder.com/150/92c952"' +
    '},' +
    '{' +
        '"albumId": 1,' +
        '"id": 2,' +
        '"title": "reprehenderit est deserunt velit ipsam",' +
        '"url": "https://via.placeholder.com/600/771796",' +
        '"thumbnailUrl": "https://via.placeholder.com/150/771796"' +
    '},' +
    '{' +
        '"albumId": 1,' +
        '"id": 3,' + 
        '"title": "officia porro iure quia iusto qui ipsa ut modi",' +
        '"url": "https://via.placeholder.com/600/24f355",' +
        '"thumbnailUrl": "https://via.placeholder.com/150/24f355"' +
    '}]';
    public static final String EXAMPLE_RESPONSE_BODY_SINGLE_RECORD = 
    '[{' +
        '"albumId": 1,' +
        '"id": 1,' +
        '"title": "accusamus beatae ad facilis cum similique qui sunt",' +
        '"url": "https://via.placeholder.com/600/92c952",' +
        '"thumbnailUrl": "https://via.placeholder.com/150/92c952"' +
    '}]';

    /**
     * Inserting specific number of standard photos
     */
    public static List<Photo__c> insertMultipleStandardPhotos(Integer noOfPhotos) {
        List<Photo__c> photos = getMultipleStandardPhotos(noOfPhotos); 
        insert photos;
        return photos;
    } 

    /**
     * Getting specific number of standard photos without inserting them to database
     */
    public static List<Photo__c> getMultipleStandardPhotos(Integer noOfPhotos) {
        List<Photo__c> photosToReturn = new List<Photo__c>();
        for(Integer i = 1; i < noOfPhotos + 1; i++) {
            photosToReturn.add(new PhotoBuilder().withExternalId(String.valueOf(i)).build());
        }
        return photosToReturn;
    }
    
    /**
     * Builder for Photo__c SObject
     */
    public class PhotoBuilder {
        private Photo__c record;

        public PhotoBuilder() {
            reset();
        }

        private Photo__c getDefaultRecord() {
            Photo__c defaultPhoto = new Photo__c();
            defaultPhoto.External_Id__c =  TEST_ID;
            defaultPhoto.Album_Id__c = TEST_ALBUM_ID;
            defaultPhoto.Thumbnail_Url__c = TEST_THUMBNAIL_URL;
            defaultPhoto.Title__c = TEST_TITLE;
            defaultPhoto.Url__c = TEST_URL;
            return defaultPhoto;
        }

        public PhotoBuilder reset() {
            record = getDefaultRecord();
            return this;
        }

        public PhotoBuilder withExternalId(String externalId) {
            record.External_Id__c = externalId;
            return this;
        }

        public Photo__c build() {
            return record;
        }

        public Photo__c buildAndSave() {
            upsert record;
            return record;
        }
    }

    public class MockExampleResponse implements HttpCalloutMock {
        
        private String responseBody;

        public MockExampleResponse() {}
        public MockExampleResponse(String responseBody) {
            this.responseBody = responseBody;
        } 

        public HttpResponse respond(HTTPrequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(201);
            if(this.responseBody != null) {
                res.setBody(this.responseBody);
            } else {
                res.setBody(EXAMPLE_RESPONSE_BODY);
            }
            res.setStatus('Success');
            return res;
        }
    }

    public static List<Photo__c> loadPhotos(List<Photo__c> photos) {
        Set<Id> photosIds = new Set<Id>();
        for (Photo__c p : photos) {
            photosIds.add(p.Id);
        }
        return Database.query(
            'SELECT ' +
                    String.join(new List<String>(Photo__c.SObjectType.getDescribe().fields.getMap().keySet()), ',') +
                    ' FROM Photo__c WHERE ID IN :photosIds'
        );
    }

}
