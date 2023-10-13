@isTest
public with sharing class StaleJobCleanUpTest {
    @isTest
    static void cleanUpJobsTest() {
        // Create a job application that is stale
        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Name = 'Test Job Application';
        jobApp.Status__c = 'New';
        jobApp.Notes__c = 'This is a test job application';
        jobApp.Follow_up_date__c = Date.today().addDays(-33);
        insert jobApp;
        Test.startTest();
        StaleJobCleanUp.cleanUpJobs();
        Test.stopTest();
        
        jobApp = [SELECT Id, Status__c, Follow_up_date__c FROM Job_Application__c WHERE Id = :jobApp.Id];
        System.assertEquals('Closed', jobApp.Status__c, 'Job application should be closed');
        System.assertEquals('Closed by automated process.', jobApp.Notes__c, 'Notes should be updated');
    }
}