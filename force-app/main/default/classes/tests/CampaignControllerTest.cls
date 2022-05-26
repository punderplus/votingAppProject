@isTest
public class CampaignControllerTest {
    @isTest
    static void getUsersTest() {
        Voting_Campaign__c vc = new Voting_Campaign__c(Name='Test');
        Test.startTest();
        insert vc;
        Test.stopTest();
        Id vcId = [SELECT Id FROM Voting_Campaign__c WHERE Name='Test' LIMIT 1].Id;
        String userType = 'CONFG';
        Integer lim = 10;
        //it should be one configurator added when Campaign is created
        System.debug(CampaignController.getUsers(vcId, lim, userType));
        System.assertEquals(1, CampaignController.getUsers(vcId, lim, userType).Size());
    }
}
