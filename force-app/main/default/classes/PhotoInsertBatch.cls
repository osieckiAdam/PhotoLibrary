/**
 * Batch for inserting Photo records. 
 */
public with sharing class PhotoInsertBatch implements Database.Batchable<SObject> {
    
    private List<Photo__c> photosToInsert;
    
    public PhotoInsertBatch(List<Photo__c> photosToInsert) {
        this.photosToInsert = photosToInsert;
    }

    public Iterable<SObject> start(Database.BatchableContext bc) {
        return photosToInsert;
    }

    public void execute(Database.BatchableContext bc, List<SObject> photosToInsert) {
        Database.insert(photosToInsert, false);
        //TODO: handle errors
    }

    public void finish(Database.BatchableContext bc) {}
}
