public with sharing class StaleJobCleanUp implements Queueable {
// Create an asynchronous process that checks if a job application is stale and moves the record status to closed. Update the notes field that the job application was closed by an automated process.
// Stale Criteria:
// Status is not Closed or Accepted
// Last Modified 30 days old or more
// Follow up date is 30 days old or more 
private Map<Id,Job_Application__c> jobApplications = new Map<Id,Job_Application__c>();
    public StaleJobCleanUp(Map<Id,Job_Application__c> jobApplications) {
        this.jobApplications = jobApplications;
    }
    public static void enqueueJob() {
       Map<Id,Job_Application__c> jobApplications = new Map <Id,Job_Application__c>([SELECT Id, Name FROM Job_Application__c WHERE Status__c != 'Closed' AND Follow_Up_Date__c < LAST_N_DAYS:30]);
        if(!jobApplications.isEmpty()){
        System.enqueueJob(new StaleJobCleanUp(jobApplications));
        }
    }
    public void execute(QueueableContext context) {
        List<Job_Application__c> jobApplicationsToUpdate = this.jobApplications.values();
        for(Job_Application__c jobApplication : jobApplicationsToUpdate){
            jobApplication.Status__c = 'Closed';
            jobApplication.Notes__c = 'Application has been closed due to inactivity longer than 30 days.';
        }
        update jobApplicationsToUpdate;
    }
}