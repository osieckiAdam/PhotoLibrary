/**
 * Helper class for tests related with Photo object
 */
public with sharing class PhotoTestHelper {

    public static final String TEST_ID = '1';
    public static final String TEST_ALBUM_ID = '1';
    public static final String TEST_THUMBNAIL_URL = 'https://via.placeholder.com/150/1fe46f';
    public static final String TEST_TITLE = 'laboriosam odit nam necessitatibus et illum dolores reiciendis';
    public static final String TEST_URL = 'https://via.placeholder.com/600/1fe46f';

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
}
