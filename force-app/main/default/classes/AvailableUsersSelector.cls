/**
 * Selects available users for lwc edit components
 */ 
public class AvailableUsersSelector {
    @AuraEnabled(cacheable=true)
    public static List<User> getAvailableUsers(ID cmpId, String userType) {
        Voting_Campaign__c vc = [SELECT ID, Voting_Campaign_Number__c FROM Voting_Campaign__c WHERE ID = :cmpId LIMIT 1];
        String filter = '%' + vc.Voting_Campaign_Number__c + '-' + userType;
        String otherFilter = '%' + vc.Voting_Campaign_Number__c + '%';
        Set<ID> groupsId = (new Map<ID, SObject>([SELECT Id FROM Group WHERE (NOT Name LIKE :otherFilter)]).keySet());
        return [
            SELECT Id, Name 
            FROM User
            WHERE ID IN (SELECT UserOrGroupId 
                         FROM GroupMember 
                         WHERE GroupId 
                         IN :groupsId
                         )
        ];
    }
}
