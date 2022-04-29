/**
 * class for mocking response for Location Callout class using HttpCalloutMock interface
 */ 
@isTest
global class LocationCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        StaticResource s = [SELECT body FROM staticresource WHERE name = 'LocatorResponse'];
        response.setBody(s.body.toString());
        response.setStatusCode(200);
        return response; 
    }
}