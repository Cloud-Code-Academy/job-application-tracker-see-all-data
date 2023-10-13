@isTest
private class JobApplicationStatusTriggerHandlerTest {

    @isTest static void testHandleAfterUpdate() {
        // Query for an existing user "Brittany Young"
        User brittanyYoung = [SELECT Id FROM User WHERE FirstName = 'Brittany' AND LastName = 'Young' LIMIT 1];

        // Ensure that Brittany Young exists
        System.assertNotEquals(null, brittanyYoung, 'Brittany Young user does not exist');

        // Create a test job application with status 'Saved'
        Job_Application__c app = new Job_Application__c(
            Status__c = 'Saved'
        );
        insert app;

        // Create a trigger context
        List<Job_Application__c> newApps = [SELECT Id, Status__c FROM Job_Application__c WHERE Id = :app.Id];
        Map<Id, Job_Application__c> oldMap = new Map<Id, Job_Application__c>{
            app.Id => new Job_Application__c(Status__c = 'Applying')
        };

        // Set the current user to Brittany Young
        System.runAs(brittanyYoung) {
            // Call the trigger handler
            JobApplicationStatusTriggerHandler.handleAfterUpdate(newApps, oldMap);

            // Verify that a task was created with Brittany Young as the OwnerId
            List<Task> tasks = [SELECT Id, OwnerId FROM Task];
            System.assertEquals(1, tasks.size(), 'Expected one task to be created');
            System.assertEquals(brittanyYoung.Id, tasks[0].OwnerId, 'Task should have Brittany Young as the Owner');
        }
    }
}
