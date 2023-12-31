@isTest
private class JobApplicationStatusTriggerHandlerTest {

    @isTest static void testHandleAfterUpdate() {
        // Create a test user "Test User"
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser' + DateTime.now().getTime() + '_seealldata@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id
        );
        insert testUser;

        // Ensure that the test user was created
        System.assertNotEquals(null, testUser, 'Test user was not created');

        // Create a test job application with status 'Saved'
        Job_Application__c savedApp = new Job_Application__c(
            Status__c = 'Saved'
        );
        insert savedApp;

        // Create a test job application with status 'Applying'
        Job_Application__c applyingApp = new Job_Application__c(
            Status__c = 'Applying'
        );
        insert applyingApp;

        // Create a test job application with status 'Applied'
        Job_Application__c appliedApp = new Job_Application__c(
            Status__c = 'Applied'
        );
        insert appliedApp;

        // Create a test job application with status 'Negotiating'
        Job_Application__c negotiatingApp = new Job_Application__c(
            Status__c = 'Negotiating'
        );
        insert negotiatingApp;

        // Create a test job application with status 'Closed'
        Job_Application__c closedApp = new Job_Application__c(
            Status__c = 'Closed'
        );
        insert closedApp;

        // Create a trigger context for 'Saved' to 'Applying' status change
        List<Job_Application__c> newApps1 = [SELECT Id, Status__c FROM Job_Application__c WHERE Id IN (:savedApp.Id, :applyingApp.Id)];
        Map<Id, Job_Application__c> oldMap1 = new Map<Id, Job_Application__c>{
            savedApp.Id => new Job_Application__c(Status__c = 'Applying'),
            applyingApp.Id => new Job_Application__c(Status__c = 'Saved')
        };

        // Set the current user to Test User
        System.runAs(testUser) {
            // Call the trigger handler for 'Saved' to 'Applying'
            JobApplicationStatusTriggerHandler.handleAfterUpdate(newApps1, oldMap1);

            // Verify that a task was created with Test User as the OwnerId
            List<Task> tasks1 = [SELECT Id, OwnerId FROM Task];
            System.assertEquals(2, tasks1.size(), 'Expected two tasks to be created');
            for (Task task : tasks1) {
                System.assertEquals(testUser.Id, task.OwnerId, 'Task should have Test User as the Owner');
            }
        }

        // Create a trigger context for 'Applying' to 'Applied' status change
        List<Job_Application__c> newApps2 = [SELECT Id, Status__c FROM Job_Application__c WHERE Id IN (:applyingApp.Id, :appliedApp.Id)];
        Map<Id, Job_Application__c> oldMap2 = new Map<Id, Job_Application__c>{
            applyingApp.Id => new Job_Application__c(Status__c = 'Applied'),
            appliedApp.Id => new Job_Application__c(Status__c = 'Applying')
        };

        // Set the current user to Test User
        System.runAs(testUser) {
            // Call the trigger handler for 'Applying' to 'Applied'
            JobApplicationStatusTriggerHandler.handleAfterUpdate(newApps2, oldMap2);

            // Verify that additional tasks were created with Test User as the OwnerId
            List<Task> tasks2 = [SELECT Id, OwnerId FROM Task];
            System.assertEquals(4, tasks2.size(), 'Expected four tasks to be created');
            for (Task task : tasks2) {
                System.assertEquals(testUser.Id, task.OwnerId, 'Task should have Test User as the Owner');
            }
        }

        // Test a status change from 'Applied' to 'Closed'
        List<Job_Application__c> newApps3 = [SELECT Id, Status__c FROM Job_Application__c WHERE Id IN (:appliedApp.Id, :closedApp.Id)];
        Map<Id, Job_Application__c> oldMap3 = new Map<Id, Job_Application__c>{
            appliedApp.Id => new Job_Application__c(Status__c = 'Closed'),
            closedApp.Id => new Job_Application__c(Status__c = 'Applied')
        };

        // Set the current user to Test User
        System.runAs(testUser) {
            // Call the trigger handler for 'Applied' to 'Closed'
            JobApplicationStatusTriggerHandler.handleAfterUpdate(newApps3, oldMap3);

            // Verify that a task was created with Test User as the OwnerId
            List<Task> tasks3 = [SELECT Id, OwnerId FROM Task];
            System.assertEquals(6, tasks3.size(), 'Expected six tasks to be created');
            for (Task task : tasks3) {
                System.assertEquals(testUser.Id, task.OwnerId, 'Task should have Test User as the Owner');
            }
        }
        
        // Test a status change from 'Applying' to 'Negotiating'
        List<Job_Application__c> newApps4 = [SELECT Id, Status__c FROM Job_Application__c WHERE Id IN (:applyingApp.Id, :negotiatingApp.Id)];
        Map<Id, Job_Application__c> oldMap4 = new Map<Id, Job_Application__c>{
            applyingApp.Id => new Job_Application__c(Status__c = 'Negotiating'),
            negotiatingApp.Id => new Job_Application__c(Status__c = 'Applying')
        };

        // Set the current user to Test User
        System.runAs(testUser) {
            // Call the trigger handler for 'Applying' to 'Negotiating'
            JobApplicationStatusTriggerHandler.handleAfterUpdate(newApps4, oldMap4);

            // Verify that additional tasks were created with Test User as the OwnerId
            List<Task> tasks4 = [SELECT Id, OwnerId FROM Task];
            System.assertEquals(8, tasks4.size(), 'Expected eight tasks to be created');
            for (Task task : tasks4) {
                System.assertEquals(testUser.Id, task.OwnerId, 'Task should have Test User as the Owner');
            }
        }
    }
}