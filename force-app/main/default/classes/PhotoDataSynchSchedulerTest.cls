@IsTest
private class PhotoDataSynchSchedulerTest {

    @IsTest
    static void when_PhotoDataSynchIsScheduled_expect_CronTriggerIsCreated() {

        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        PhotoDataSynchScheduler.ScheduleJobDaily();
        Test.stopTest();

        //then
        List<CronTrigger> cronTriggers = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name =: PhotoDataSynchScheduler.JOB_NAME
        ];
        System.assertEquals(1, cronTriggers.size(), 'Expecting one cron trigger is created for PhotoDataSynchScheduler ');
    }

    @IsTest
    static void when_PhotoDataSynchIsScheduledAndItIsAlreadyScheduled_expect_CronTriggerIsDeletedAndNewOneIsCreated() {

        //when
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PhotoTestHelper.MockExampleResponse());
        PhotoDataSynchScheduler.ScheduleJobDaily();
        Test.stopTest();

        //then
        List<CronTrigger> cronTriggers = [
            SELECT Id 
            FROM CronTrigger 
            WHERE CronJobDetail.Name =: PhotoDataSynchScheduler.JOB_NAME
        ];
        System.assertEquals(1, cronTriggers.size(), 'Expecting one cron trigger is created for PhotoDataSynchScheduler ');
    }
}
