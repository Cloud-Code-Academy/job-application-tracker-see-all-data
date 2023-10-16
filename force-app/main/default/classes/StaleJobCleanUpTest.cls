@isTest
public with sharing class StaleJobCleanUpTest {
    @isTest
    static void cleanUpJobsTest() {
        // Create a job application that is stale
       List<Job_Application__c> cleanUpTest = new List<Job_Application__c>();
       for (Integer i = 0; i < 200; i++) {
           Job_Application__c jobApp = new Job_Application__c();
           jobApp.Name = 'Test Job Application ' + i;
           jobApp.Status__c = 'Applying';
           jobApp.Follow_up_date__c = Date.today().addDays(-33);
           cleanUpTest.add(jobApp);
       }
        insert cleanUpTest;
        Test.startTest();
        StaleJobCleanUp.cleanUpJobs();
        Test.stopTest();
        // Verify that the job applications were updated
        List<Job_Application__c> updatedJobApps = [SELECT Id, Status__c, Notes__c FROM Job_Application__c WHERE Id IN :cleanUpTest];
        for(Job_Application__c jobApp : updatedJobApps) {
            System.assertEquals('Closed', jobApp.Status__c,'Job applications were not updated');
            System.assertEquals('Closed by automated process.', jobApp.Notes__c,'Job application notes were not updated');
        }
    }
}