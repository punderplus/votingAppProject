/**
 * Selects available users for lwc edit components
 */ 
public class UsersToEditController {
    /**
     * @description return users who are not part of campaign and users of campaign with particular record type
     * @param  cmpId id of campaign, recortTp - string of name of record type
     * @return  returns list of available to add to campaign
     */ 
    @AuraEnabled(cacheable=true)
    public static List<User> getAllAvailableUsers(ID cmpId, String recordTp) {
        //getting ids of all users who are not part of campaign
        List<Voting_Campaign_Role__c> vcrs = [SELECT User__r.Id 
                             FROM Voting_Campaign_Role__c
                             WHERE Voting_Compaign__r.Id = :cmpId];
        List<Id> userIdso = new List<Id>();
        for(Voting_Campaign_Role__c vcr: vcrs){
            userIdso.add(vcr.User__r.Id);
        }
        //getting ids of all users who are part of campaign with particular recordTp
        List<Voting_Campaign_Role__c> vcrsRec = [SELECT User__r.Id 
                             FROM Voting_Campaign_Role__c
                             WHERE Voting_Compaign__r.Id = :cmpId
                             AND RecordTypeId IN
                                (SELECT Id 
                                 FROM RecordType 
                                 WHERE sObjectType = 'Voting_Campaign_Role__c' 
                                 AND DeveloperName IN (:recordTp))];
        List<Id> userIds = new List<Id>();
        for(Voting_Campaign_Role__c vcr: vcrsRec){
            userIds.add(vcr.User__r.Id);
        }
        return [
            SELECT Id, Name
            FROM User
            WHERE Id IN :userIds
            OR Id NOT IN :userIdso
        ];
    }
    /**
     * @description get users for selected by default box
     * @param  cmpId    cmpId id of campaign
     * @param  recordTp record type name
     * @return  list of Users name
     */ 
    @AuraEnabled(cacheable=true)
    public static List<Voting_Campaign_Role__c> getCurrentUsers(ID cmpId, String recordTp) {
        return [
            SELECT User__r.Name
            FROM Voting_Campaign_Role__c
            WHERE Voting_Compaign__r.Id = :cmpId
            AND RecordTypeId IN
                (SELECT Id 
                    FROM RecordType 
                    WHERE sObjectType = 'Voting_Campaign_Role__c' 
                    AND DeveloperName IN (:recordTp))
        ];
    }
}
