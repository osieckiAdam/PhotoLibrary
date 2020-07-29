/**
 * Class for scheduling Photo Data Synch Batch Job
 */
global with sharing class PhotoDataSyncJob implements Schedulable {
    global void execute(SchedulableContext ctx) {
        //TODO move batch scope to custom settings
        Database.executeBatch(new PhotoDataSynchBatch(), 200);
    }
}
