/**
 * Scheduler for Photo Data Synch Batch Job. Use public method 
 * ScheduleJobDaily, to add job which will be executing every day
 * at 0:00 GMT
 */
public with sharing class PhotoDataSynchScheduler {
    public static final String JOB_NAME = 'Photo Data Synch Job';

    /**
     * Use this class to set schedulable job
     */
    public static void scheduleJobDaily() {
        //TODO: move Job configuration to Custom Metadata
        abortExistingJobs();
        PhotoDataSyncJob pdsj = new PhotoDataSyncJob();
        System.Schedule(JOB_NAME, '0 0 0 * * ?', pdsj);
    }

    private static void abortExistingJobs() {
        List<CronTrigger> cronTriggers = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name =: JOB_NAME
        ];
        for(CronTrigger c : cronTriggers) {
            System.abortJob(c.Id);
        }
    }

    public with sharing class PhotoDataSyncJob implements Schedulable {
        public void execute(SchedulableContext ctx) {
            //TODO move batch scope to custom settings
            Database.executeBatch(new PhotoDataSynchBatch(), 200);
        }
    }
}
