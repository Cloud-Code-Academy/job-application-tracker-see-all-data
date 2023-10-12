public with sharing class JoobleCallout {
    public JoobleCallout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:JoobleNamedCredential');
        req.setMethod('POST');
        
        //bunch of cool stuff happens

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());

        if (res.getStatusCode() == 200) {
            //replace this part with method?
            Job_Application__c jobApp = new Job_Application__c();
            jobApp.Status__c = 'Saved';
            insert jobApp; 
        }

    }

    private static Job_Application__c createSavedJobApplication(String jsonResponse){
        return null;

    }


}