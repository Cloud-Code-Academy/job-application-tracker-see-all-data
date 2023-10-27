public with sharing class StaleJobCleanUp {
// Create an asynchronous process that checks if a job application is stale and moves the record status to closed. Update the notes field that the job application was closed by an automated process.
// Stale Criteria:
// Status is not Closed or Accepted
// Last Modified 30 days old or more
@future
public static void cleanUpJobs() {
    List<Job_Application__c> jobApplications = [SELECT Id, Name, Status__c, Follow_up_date__c  FROM Job_Application__c WHERE Status__c != 'Closed' AND Status__c != 'Accepted' AND Follow_up_date__c < LAST_N_DAYS:30];
    for(Job_Application__c jobApplication : jobApplications) {
        jobApplication.Status__c = 'Closed';
        jobApplication.Notes__c = 'Closed by automated process.';
        }
    update jobApplications;
    }
}