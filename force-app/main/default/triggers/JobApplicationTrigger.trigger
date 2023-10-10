trigger JobApplicationTrigger on Job_Application__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        JobApplicationStatusTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}

