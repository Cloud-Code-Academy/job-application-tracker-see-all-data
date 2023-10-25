public with sharing class JoobleCalloutMockGenerator implements HttpCalloutMock {
    public HttpResponse respond(HTTPRequest req) {
        //Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        //Check if the request is a POST request
        if(req.getMethod() == 'POST') {
            //Return a success response for the POST request
            res.setBody('{"jobs": [{"status": "Saved", "salary": "80000.00", "link": "www.google.com"}]}');
        }
        res.setStatusCode(200);
        return res;
    }
}