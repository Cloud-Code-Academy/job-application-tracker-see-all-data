public with sharing class JoobleCallout {
    @future (callout = true)
    public static void getJoobleDetails(String keywords, String location, String datecreatedfrom, Integer page) {
        List<Job_Application__c> parsedJobApp = new List<Job_Application__c>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Jooble_Named_Credential');
        //req.setEndpoint('https://jooble.org/api/4973a10c-0cb9-4f66-aa9e-6d1f02d1d2de');
        req.setMethod('POST');

// Construct the JSON payload to send with the POST request
        Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('keywords', keywords);
            requestBody.put('location', location);
            requestBody.put('datecreatedfrom', datecreatedfrom);
            requestBody.put('page', page);
        
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(requestBody));
        // req.setEndpoint(req.getEndpoint() +
        // '?keywords=' + keywords +
        // '&location=' + location +
        // '&datecreatedfrom=' + datecreatedfrom +
        // '&page=' + String.valueOf(page));

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());

        if (res.getStatusCode() == 200) {
            //replace this part with method?
            parsedJobApp = createSavedJobApplication(res.getBody());
            insert parsedJobApp; 
        
    } else {
        System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
    }
}

    //Fields from JSON: keywords, location, datecreatedfrom (string format yyy-mm-dd), page

    private static List<Job_Application__c> createSavedJobApplication(String jsonResponse){
        
        
        List<Job_Application__c> jobAppList  = new List<Job_Application__c>();
        //List<Object> jobListings = (List<Object>) JSON.deserializeUntyped(jsonResponse);
        Map<String, Object> parsedResponse = (Map<String,Object>) JSON.deserializeUntyped(jsonResponse);
        if(parsedResponse.containsKey('jobs')){
            List<Object> jobListings = (List<Object>) parsedResponse.get('jobs');

        for(Object jobListing : jobListings ) {
            if(jobListing instanceof Map<String,Object>){
        Map<String,Object> jobData = (Map<String,Object>) jobListing;
        //List<Object> jobAlternateData = (List<Object>) jobListing;
        Job_Application__c jobApp = new Job_Application__c();     
        jobApp.Application_Date__c = Date.today();
        jobApp.Name = (String) jobData.get('title') + ' Application';
        jobApp.Position_Title__c = (String) jobData.get('title');
        jobApp.URL__c = (String) jobData.get('link');
        jobApp.Location__c = (String) jobData.get('location');
        String salaryString = (String) jobData.get('salary');
        Decimal jobSalary;
        
        try {
            jobSalary = Decimal.valueOf(salaryString);
        } catch (System.TypeException e) {
            // Handle the case where the salary string is not a valid decimal
            // You can log an error, set a default value, or take appropriate action.
            jobSalary = 0.0; // Setting a default value (you can choose a different default)
        }
        
        jobApp.Salary__c = jobSalary;
        
        jobApp.Status__c = 'Saved';

        jobAppList.add(jobApp);

        }
    }
}

        return jobAppList;
   
    }
}