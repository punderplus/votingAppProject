/**
 * class to test Location Callout class
 */ 
@isTest
public class LocationCalloutTest {
    /**
     * @description method to test web service integration
     */ 
    @isTest static void testGetCallout() {
        //getting mock response
        Test.setMock(HttpCalloutMock.class, new LocationCalloutMock());
        LocationCallout lc = new LocationCallout();
        Voting_Location__c vl = new Voting_Location__c();
        vl.Country__c = 'Brasil';
        vl.City__c = 'Carapicuíba';
        vl.Address__c = '';
        vl = lc.makeGetCallout(vl);
        //testing equals of coords
        System.assertEquals('-23.5370411', vl.Latitude__c);
        System.assertEquals('-46.835665', vl.Longitude__c);
    }
}