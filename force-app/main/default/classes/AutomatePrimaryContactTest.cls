@isTest
public with sharing class AutomatePrimaryContactTest {
    @isTest
    static void testAutomatePrimaryContact() {

        Account acct = new Account(Name = 'Test');
        insert acct;

        Contact con = new Contact(LastName = 'Towers', FirstName = 'Jason', AccountId = acct.Id);
        insert con;

        Job_Application__c testJobApp = new Job_Application__c(Company_Name__c = acct.Id);
        insert testJobApp;

        Job_Application__c testJobAppNoContact = new Job_Application__c();
        insert testJobAppNoContact;

        AutomatePrimaryContact.assignPrimaryContact(new List<Job_Application__c>{testJobAppNoContact, testJobApp});

        testJobAppNoContact = [SELECT Primary_Contact__c FROM Job_Application__c WHERE Id = :testJobAppNoContact.Id];
        testJobApp = [SELECT Primary_Contact__c FROM Job_Application__c WHERE Id = :testJobApp.Id];

        System.assertEquals(null, testJobAppNoContact.Primary_Contact__c);
        System.assertEquals(con.Id, testJobApp.Primary_Contact__c);

    }
}