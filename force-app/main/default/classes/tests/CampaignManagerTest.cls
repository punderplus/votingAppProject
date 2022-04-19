@isTest
public with sharing class CampaignManagerTest {
    /**
     * tests for CampaignManager class methods
     */ 

    /**
     * @description bulk test of createGroups method
     */ 
    @isTest
    public static void createGroupsTest() {
        //creating and inserting initial list of cmps
        List<Voting_Campaign__c> cmps = new List<Voting_Campaign__c>();
        for(Integer i = 0; i < 50; i++){
            cmps.add(new Voting_Campaign__c());
        }
        insert cmps;
        //creating list of ids of cmps
        List<Id> cmpsIds = new List<Id>();
        for (Voting_Campaign__c cmp: cmps){
            cmpsIds.add(cmp.Id);
        }
        //getting filters 
        String[] filters = new String[]{};
        for(Voting_Campaign__c vc: [select id, Voting_Campaign_Number__c from Voting_Campaign__c where id in :cmpsIds]){
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        System.assertEquals(200, [select count() from Group where Name like :filters]);
    }
}
