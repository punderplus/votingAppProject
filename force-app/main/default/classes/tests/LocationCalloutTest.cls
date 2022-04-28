@isTest
public class LocationCalloutTest {
    @isTest static void testGetCallout() {
        Test.setMock(HttpCalloutMock.class, new LocationCalloutMock());
        LocationCallout lc = new LocationCallout();
        Voting_Location__c vl = new Voting_Location__c();
        vl.Country__c = 'Brasil';
        vl.City__c = 'Carapicuíba';
        vl.Address__c = '';
        vl = lc.makeGetCallout(vl);
        System.assertEquals('23° 32\' 14.49456\'\' S', vl.Latitude__c);
        System.assertEquals('46° 50\' 14.81748\'\' W', vl.Longitude__c);
    }
}