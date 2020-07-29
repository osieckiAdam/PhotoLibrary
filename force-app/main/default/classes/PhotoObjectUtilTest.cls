@IsTest
public with sharing class PhotoObjectUtilTest {

    @IsTest
    static void should_ReturnTrue_when_AllTrackedCustomFieldsAreEqual() {
        //given
        Photo__c photo1 = new PhotoTestHelper.PhotoBuilder().build();
        Photo__c photo2 = new PhotoTestHelper.PhotoBuilder().build();

        //when
        Test.startTest();
        Boolean arePhotosEqual = PhotoObjectUtil.areEqual(photo1, photo2);
        Test.stopTest();

        //then
        System.assert(arePhotosEqual, 'Expecting that photos are equal');
    }

    @IsTest
    static void should_ReturnFalse_when_TrackedCustomFieldsAreNotEqual() {
        //given
        Photo__c photo1 = new PhotoTestHelper.PhotoBuilder().build();
        Photo__c photo2 =  new PhotoTestHelper.PhotoBuilder().withExternalId('2').build();

        //when
        Test.startTest();
        Boolean arePhotosEqual = PhotoObjectUtil.areEqual(photo1, photo2);
        Test.stopTest();

        //then
        System.assert(!arePhotosEqual, 'Expecting that photos are not equal');
    }

    @IsTest
    static void should_Parse_JSONDataToPhoto() {
        //given
        String testFetchedData = PhotoTestHelper.EXAMPLE_RESPONSE_BODY_SINGLE_RECORD;
        Map<String, Object> fetchedRecordAsMap = 
            (Map<String,Object>)(((List<Object>)JSON.deserializeUntyped(testFetchedData))[0]);

        //when
        Test.startTest();
        Photo__c parsedPhoto = PhotoObjectUtil.parseExternalRecordToPhoto(fetchedRecordAsMap);
        Test.stopTest();

        //then
        System.assertEquals('1', parsedPhoto.Album_Id__c, 'Expecting specific value of parsed Photo Album Id');
        System.assertEquals('1', parsedPhoto.External_Id__c, 'Expecting specific value of parsed Photo External Id');
        System.assertEquals('accusamus beatae ad facilis cum similique qui sunt', parsedPhoto.Title__c, 
            'Expecting specific value of parsed Photo Title');
        System.assertEquals('https://via.placeholder.com/600/92c952', parsedPhoto.Url__c, 
            'Expecting specific value of parsed Photo Url');
        System.assertEquals('https://via.placeholder.com/150/92c952', parsedPhoto.Thumbnail_Url__c, 
            'Expecting specific value of parsed Photo Thumbnail Url');
    }
}