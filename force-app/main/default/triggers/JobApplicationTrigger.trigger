trigger JobApplicationTrigger on Job_Application__c (before insert, before update, after update) {

    // For Tax calculations
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        TakeHomeCalculations.calculateLiabilities(Trigger.new);
    }
    
    // For Job Application Status
    if(Trigger.isAfter && Trigger.isUpdate) {
        JobApplicationStatusTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
    AutomatePrimaryContact.assignPrimaryContact(Trigger.new);
    }
}