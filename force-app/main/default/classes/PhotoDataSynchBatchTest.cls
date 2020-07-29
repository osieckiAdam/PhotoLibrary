@IsTest
public with sharing class PhotoDataSynchBatchTest {

    @IsTest
    static void should_insertMultiplePhotos() {
        
        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        Database.executeBatch(new PhotoDataSynchBatch(), 200);
        Test.stopTest();

        //then
        List<Photo__c> insertedPhotos = [SELECT Id FROM Photo__c];
        System.assertEquals(3, insertedPhotos.size(), 'Expecting specific number of Photos were inserted');
    }

    @IsTest
    static void should_updateMultiplePhotos() {

        //given
        List<Photo__c> photos = PhotoTestHelper.insertMultipleStandardPhotos(3);
        for(Photo__c p : PhotoTestHelper.loadPhotos(photos)){
            System.assertEquals(PhotoTestHelper.TEST_URL, p.Url__c, 'Checking value of URL');
        }

        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        Database.executeBatch(new PhotoDataSynchBatch(), 200);
        Test.stopTest();

        //then
        photos = PhotoTestHelper.loadPhotos(photos);
        System.assertEquals(3, photos.size(), 'Expecting specific number of photos are in database after synchronization');
        for(Photo__c p : photos){
            System.assertNotEquals(PhotoTestHelper.TEST_URL, p.Url__c, 'Expecting that photos are updated');
        }
    }

    @IsTest
    static void should_deleteAndUpdateMultiplePhotos() {
        
        //given
        List<Photo__c> photos = PhotoTestHelper.insertMultipleStandardPhotos(5);
        for(Photo__c p : PhotoTestHelper.loadPhotos(photos)){
            System.assertEquals(PhotoTestHelper.TEST_URL, p.Url__c, 'Checking value of URL');
        }
        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        Database.executeBatch(new PhotoDataSynchBatch(), 200);
        Test.stopTest();

        //then
        List<Photo__c> notDeletedPhotos = [SELECT Id FROM Photo__c];
        System.assertEquals(3, notDeletedPhotos.size(), 
            'Expecting specific number of Photos are in database after synchronization');

        photos = PhotoTestHelper.loadPhotos(photos);
        System.assertEquals(3, photos.size(), 'Expecting specific number of photos are in database after synchronization');
        for(Photo__c p : photos){
            System.assertNotEquals(PhotoTestHelper.TEST_URL, p.Url__c, 'Expecting that photos are updated');
        }
    }

    @IsTest
    static void should_deleteAllExistingPhotos() {

        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse('[]'));
        Database.executeBatch(new PhotoDataSynchBatch(), 200);
        Test.stopTest();

        //then
        List<Photo__c> insertedPhotos = [SELECT Id FROM Photo__c];
        System.assertEquals(0, insertedPhotos.size(), 'Expecting all Photos were deleted');
    }
}
