/**
 * This class contains util methods for working with Photo__c object
 */
public with sharing class PhotoObjectUtil {
    
    /**
     * This method will compare two records by comparing their properties which are 
     * synchronized between external system and Salesforce
     */
    public static Boolean areEqual(Photo__c firstPhoto, Photo__c secondPhoto) {

        for(Photo_Data_Field_Mapping__mdt pdfm : CustomMetadataSelector.getPhotoDataFieldMappingMetadata()) {
            if(firstPhoto.get(pdfm.Salesforce_Field_Name__c) != secondPhoto.get(pdfm.Salesforce_Field_Name__c)) {
                return false;
            }
        }
        return true;
    }

    /**
     * This method will return Photo__c object basing on the records fetched from the external system.able 
     * All fields from Custom Metadata mapping will be parsed to SObject
     */
    public static Photo__c parseExternalRecordToPhoto(Map<String, Object> externalRecord) {
        Photo__c parsedPhoto = new Photo__c();
        for(Photo_Data_Field_Mapping__mdt pdfm : CustomMetadataSelector.getPhotoDataFieldMappingMetadata()) {
            parsedPhoto.put(
                pdfm.Salesforce_Field_Name__c, String.valueOf(externalRecord.get(pdfm.External_Field_Name__c)));
        }
        return parsedPhoto;
    }
}
