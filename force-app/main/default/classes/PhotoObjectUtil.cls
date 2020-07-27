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
            System.debug(LoggingLevel.ERROR, pdfm.Salesforce_Field_Name__c);
            if(firstPhoto.get(pdfm.Salesforce_Field_Name__c) != secondPhoto.get(pdfm.Salesforce_Field_Name__c)) {
                return false;
            }
        }
        return true;
    }
}
