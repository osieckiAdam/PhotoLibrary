@IsTest
public with sharing class CustomMetadataSelectorTest {
    
    @IsTest
    static void should_ReturnPhotoDataFieldMappings() {

        //when
        Test.startTest();
        List<Photo_Data_Field_Mapping__mdt> metadata = CustomMetadataSelector.getPhotoDataFieldMappingMetadata();
        Test.stopTest();

        //then
        System.assert(metadata.size() > 0, 'Expecting metadata records are returned');
    }
}
