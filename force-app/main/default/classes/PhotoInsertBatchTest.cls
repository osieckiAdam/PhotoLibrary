@IsTest
public with sharing class PhotoInsertBatchTest {

    @IsTest
    static void should_InsertMultiplePhotos() {
        //given 
        Integer noOfPhotosToInsert = 200;
        List<Photo__c> photosToInsert = PhotoTestHelper.getMultipleStandardPhotos(noOfPhotosToInsert);

        //when
        Test.startTest();
        Database.executeBatch(new PhotoInsertBatch(photosToInsert));
        Test.stopTest();

        //then
        List<Photo__c> insertedPhotos = [SELECT Id FROM Photo__c];
        System.assertEquals(noOfPhotosToInsert, insertedPhotos.size(), 
            'Expecting that ' + noOfPhotosToInsert + ' photos are inserted');
    }
}
