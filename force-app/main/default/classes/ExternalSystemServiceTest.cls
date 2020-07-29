@IsTest
public with sharing class ExternalSystemServiceTest {
    
    @IsTest
    static void should_getIncomingPhotosByExternalId() {

        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        Map<String, Photo__c> fetchedPhotos = ExternalSystemService.getInstance().getIncomingPhotosByExternalId();
        Test.stopTest();

        //then
        System.assertEquals(3, fetchedPhotos.size(), 'Expecting specific numer of record were fetched');
    }
}