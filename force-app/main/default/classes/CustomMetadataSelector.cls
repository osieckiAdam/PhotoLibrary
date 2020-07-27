/**
 * Class used for accessing Custom Metadata records
 */
public with sharing class CustomMetadataSelector {

    private static Photo_Data_Field_Mapping__mdt[] photoDataFieldMapping = null;

    /**
     * Returns all Photo Data Field Mappings records marked as active
     */
    public static Photo_Data_Field_Mapping__mdt[] getPhotoDataFieldMappingMetadata() {
        initPhotoDataFieldMappingMetadata();
        return photoDataFieldMapping;
    }

    private static void initPhotoDataFieldMappingMetadata() {
        if (photoDataFieldMapping == null) {
            photoDataFieldMapping = [
                SELECT Id, External_Field_Name__c, Salesforce_Field_Name__c 
                FROM Photo_Data_Field_Mapping__mdt 
                WHERE Is_Active__c = true
            ];
        }
    }
}