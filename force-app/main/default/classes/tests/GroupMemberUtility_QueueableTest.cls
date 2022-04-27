/**
 * Test for queueable class related to GroupMember object
 */ 
@isTest
public with sharing class GroupMemberUtility_QueueableTest {
    /**
     * @description setup description
     */ 
    @TestSetup
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
     * @description testing if creator of Voting Campaign object is assigned to every configurators group related to this object 
     */ 
    @isTest
    static void confAssignmentTest(){
        //creating list of ids of cmps
        List<Id> cmpsIds = new List<Id>();
        for (Voting_Campaign__c cmp: [SELECT Id FROM Voting_Campaign__c WHERE Name LIKE 'Test%']){
            cmpsIds.add(cmp.Id);
        }
        //getting filters 
        List<String> filters = new List<String>();
        for(Voting_Campaign__c vc: [select id, Voting_Campaign_Number__c from Voting_Campaign__c where id in :cmpsIds]){
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        //All newGroups
        List<Group> newGroups = [SELECT Id FROM Group WHERE Name LIKE :filters];
        List<Id> newGroupsId = new List<Id>();
        for(Group g: newGroups){
            newGroupsId.add(g.ID);
        }
        //should be 50 group members for 50 configurators groups
        Integer actual = [SELECT count() FROM GroupMember WHERE GroupId in :newGroupsId];
        System.assertEquals(50, actual);
    }
}
