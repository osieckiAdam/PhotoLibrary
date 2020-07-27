@IsTest
public with sharing class PhotoObjectUtilTest {

    @IsTest
    static void should_ReturnTrue_when_AllTrackedCustomFieldsAreEqual(){
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
    static void should_ReturnFalse_when_TrackedCustomFieldsAreNotEqual(){
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



}
