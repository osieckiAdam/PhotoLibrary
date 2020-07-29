//INITIAL RUN
//THIS SCRIPT WILL TRIGGER THE SYNCHRONIZATION AND SET SCHEDULED JOB FOR DAILY SYNCHRONIZATION

if([SELECT Count() FROM Photo__c] < 5000) {
    //TODO move batch scope size to Settings
    Database.executeBatch(new PhotoDataSynchBatch(), 200);

}
PhotoDataSynchScheduler.scheduleJobDaily();