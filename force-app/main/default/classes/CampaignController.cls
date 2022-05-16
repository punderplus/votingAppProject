/**
 * class to control getting moderator for campaigns
 */ 
public with sharing class CampaignController {
    /**
     * @description method to get list of moders for campaign(from public groups)
     * @param  cmpId - id of campaign to get moders
     * @return list of moders(Lastname and Firstname)
     */ 
    @AuraEnabled
    public static List<User> getUsers(ID cmpId, Integer lim, String userType) {
        Voting_Campaign__c vc = [SELECT ID, Voting_Campaign_Number__c FROM Voting_Campaign__c WHERE ID = :cmpId LIMIT 1];
        String filter = '%' + vc.Voting_Campaign_Number__c + '-' + userType;
        Set<ID> groupsId = (new Map<ID, SObject>([SELECT Id FROM Group WHERE Name LIKE :filter]).keySet());
        return [
            SELECT Id, Name, Username
            FROM User
            WHERE ID IN (SELECT UserOrGroupId 
                         FROM GroupMember 
                         WHERE GroupId 
                         IN :groupsId
                         )
            LIMIT :lim 
        ];
    }
}
