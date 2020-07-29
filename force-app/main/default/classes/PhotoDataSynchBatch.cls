public with sharing class PhotoDataSynchBatch implements Database.Batchable<SObject>, Database.Stateful, 
    Database.AllowsCallouts {

    private Map<String, Photo__c> incomingPhotos;
    private static final String QUERY = 
        'SELECT Id, Album_Id__c, External_Id__c, Title__c, Url__c, Thumbnail_Url__c ' + 
        'FROM Photo__c';

    @TestVisible
    private static final Integer INSERT_JOB_TRESHOLD = 200;

    public Database.QueryLocator start(Database.BatchableContext BC) {

        this.incomingPhotos = ExternalSystemService.getInstance().getIncomingPhotosByExternalId();
        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext bc, List<SObject> localPhotos) {
        List<Photo__c> localPhotosToDelete = new List<Photo__c>();
        List<Photo__c> localPhotosToUpdate = new List<Photo__c>();

        for(Photo__c localPhoto : (List<Photo__c>) localPhotos) {
            Photo__c externalPhoto = incomingPhotos.get(localPhoto.External_Id__c); 
            
            //Case 1: Photo was deleted from external server
            if(externalPhoto == null) {
                localPhotosToDelete.add(localPhoto);
            } else {
                //Case 2: Photo exists on external server but it was updated
                if(!PhotoObjectUtil.areEqual(externalPhoto, localPhoto)) {
                    externalPhoto.Id = localPhoto.Id;
                    localPhotosToUpdate.add(externalPhoto);
                }
                //Case 3: Photo exists on external server and is the same as local version
                //no action needed

                this.incomingPhotos.remove(localPhoto.External_Id__c);
            }
        }
        if(localPhotosToDelete.size() > 0) {
            Database.delete(localPhotosToDelete, false);
            //TODO: handle errors
        }
        if(localPhotosToUpdate.size() >0) {
            Database.update(localPhotosToUpdate, false);
            //TODO: handle errors
        }
    }

    public void finish(Database.BatchableContext bc) {
        //If any photos are not removed from incoming Photos then it means that they are new photos
        if(this.incomingPhotos.size() != 0) {
            if(this.incomingPhotos.size() > INSERT_JOB_TRESHOLD) {
                Database.executeBatch(new PhotoInsertBatch(this.incomingPhotos.values()), 200);
            } else {
                //TODO: handle errors
                Database.insert(this.incomingPhotos.values(), false);
            }
        }
    }

}
