@isTest
public with sharing class JoobleCalloutTest {
    //This test method will mock test the getJoobleDetails future method with a mock HTTP response.
    @isTest
    static void testGetJoobleDetails() {
       
        Test.setMock(HttpCalloutMock.class, new JoobleCalloutMockGenerator());

        String keywords = 'Salesforce';
        String location = 'San Francisco';
        String datecreatedfrom = '2023-10-17';
        Integer page = 1;

        Test.startTest();
        JoobleCallout.getJoobleDetails(keywords, location, datecreatedfrom, page);
        Test.stopTest();

        List<Job_Application__c> jobApps =[SELECT Status__c, URL__c, Salary__c FROM Job_Application__c];
        System.assertEquals(1, jobApps.size());
        Job_Application__c jobApp = jobApps[0];
        System.assertEquals('Saved', jobApp.Status__c);
        System.assertEquals(80000, jobApp.Salary__c);
        System.assertEquals('www.google.com', jobApp.URL__c);

    }

    }
