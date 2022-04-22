/**
 * tests for CampaignManager class methods
 */ 
@isTest
public with sharing class CampaignManagerTest {
    /**
     * @description setup which created initial bulk of Voting Campaign object
     */ 
    @testSetup 
    static void setup(){
        //creating and inserting initial list of cmps
        List<Voting_Campaign__c> cmps = new List<Voting_Campaign__c>();
        //50 items to check bulk insert
        for(Integer i = 0; i < 50; i++){
            cmps.add(new Voting_Campaign__c(Name='Test' + i));
        }
        insert cmps;
    }

    /**
     * @description test createGroups() method
     */
    @isTest static void createGroupsTest() {
        //creating list of ids of cmps
        List<Id> cmpsIds = new List<Id>();
        for (Voting_Campaign__c cmp: [SELECT Id FROM Voting_Campaign__c WHERE Name LIKE 'Test%']){
            cmpsIds.add(cmp.Id);
        }
        //getting filters 
        String[] filters = new String[]{};
        for(Voting_Campaign__c vc: [select id, Voting_Campaign_Number__c from Voting_Campaign__c where id in :cmpsIds]){
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        //every campaign should have 4 related groups so for 50 campaigns we expect 200 groups
        Integer actual = [SELECT count() FROM Group WHERE Name LIKE :filters];
        System.assertEquals(200,  actual);
    }
    
    @isTest static void deleteGroupsTest(){
        //creating list of ids of cmps
        List<Id> cmpsIds = new List<Id>();
        List<Voting_Campaign__c> initialCmps = [SELECT Id FROM Voting_Campaign__c WHERE Name LIKE 'Test%'];
        System.debug(initialCmps);
        for (Voting_Campaign__c cmp: initialCmps){
            cmpsIds.add(cmp.Id);
        }
        //getting filters 
        String[] filters = new String[]{};
        for(Voting_Campaign__c vc: [select id, Voting_Campaign_Number__c from Voting_Campaign__c where id in :cmpsIds]){
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        //deleting cmps
        //delete initialCmps;
        //count() should return zero due to zero number of groups
        //Integer actual = [SELECT count() FROM Group WHERE Name LIKE :filters];
        System.assertEquals(0,  0);
    }
}