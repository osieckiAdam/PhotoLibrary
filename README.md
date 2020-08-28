# PhotoLibrary Lightning Web Components Sample Application

Formal requirements for this application were following: 
To build an image search app:
 
-	Records can be fetched from https://jsonplaceholder.typicode.com/photos and are stored in Salesforce
-	Images are synchronized daily (please remember that photos removed from external API should also be removed from Salesforce)
-	Build lightning app to display records
-	Provide search engine to filter record based on the title
-	Allow to send list of filtered records to email address
-	Please provide a link to github repo with your app

## Table of contents

-   [Installing PhotoGalery using a Developer Edition Org or a Trailhead Playground](#installing-photolibrary-using-a-developer-edition-org-or-a-trailhead-playground)

-   [Salesforce Application Walkthrough](#salesforce-application-walkthrough)


## Installing PhotoLibrary using a Developer Edition Org or a Trailhead Playground

1. Clone this repository, or download it using GitHub, deploy code on Your environment
2. After deploying the code there will be no data. Batch job will also be not scheduled. In order to import data and schedule job run anonymous code which can be found in scripts\apex\InitialRun.apex, You can also copy the following code:

```
//INITIAL RUN

//IF RECORDS ARE NOT SYCHED TO SALESFORCE, RUN SYNCHRONIZATION BATCH NOW
if([SELECT Count() FROM Photo__c] < 5000) {
    Database.executeBatch(new PhotoDataSynchBatch(), 200);

}
//RUN SCHEDULER
PhotoDataSynchScheduler.scheduleJobDaily();
```

## Salesforce Application Walkthrough

0. Records are synchronised by nightly batch job. It is scheduled by default on 0:00 GMT. Batch is querying all records from the external system. In case that any record on Salesforce side is different it will be updated, records are matched by the Id field (which is External_Id__c on Salesforce side). If records are removed from external server then they will be also deleted by the batch.
1. Our app can be found in AppSwitcher under PL icon, it contains one tab: Search 
2. You can use the search bar on the left to filter Photo records by the Title. Results are updated after each search key change.
3. In the bottom right corner of the Search Result component You can put Your email address and send JSON string with search result to provided address.
