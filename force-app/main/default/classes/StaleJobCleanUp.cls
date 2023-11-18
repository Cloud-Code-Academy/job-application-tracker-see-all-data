global class StaleJobCleanUp implements Schedulable {
// Create an asynchronous process that checks if a job application is stale and moves the record status to closed. Update the notes field that the job application was closed by an automated process.
// Stale Criteria:
// Status is not Closed or Accepted
// Last Modified 30 days old or more
// Follow up date is 30 days old or more 
    global void execute(SchedulableContext sc) {
        List<Job_Application__c> jobApplicationsToUpdate = [SELECT Id, Name, Status__c, Follow_Up_Date__c 
        FROM Job_Application__c 
        WHERE Status__c != 'Closed' AND Status__c != 'Accepted' AND Follow_Up_Date__c < LAST_N_DAYS:30];

        if(!jobApplicationsToUpdate.isEmpty()){
        for(Job_Application__c jobApplication : jobApplicationsToUpdate){
            jobApplication.Status__c = 'Closed';
            jobApplication.Notes__c = 'Application has been closed due to inactivity longer than 30 days.';
        }
        update jobApplicationsToUpdate;
    }     
  }
}