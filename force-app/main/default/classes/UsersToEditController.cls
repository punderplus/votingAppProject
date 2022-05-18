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

    @AuraEnabled
    public static void insertUsers(Id cmpId, String recordTp, List<Id> oldIds, List<Id> newIds){
        //get old set of users and new set of users
        Set<User> oldUsers = new Set<User>([SELECT Id, Name FROM User WHERE Id IN :oldIds]);
        Set<User> newUsers = new Set<User>([SELECT Id, Name FROM User WHERE Id IN :newIds]);
        //get set of all deleted and added users
        Set<User> allUsers = oldUsers.clone();
        allUsers.addAll(newUsers);
        //get set of users to be deleted
        Set<User> usersToDelete = allUsers.clone();
        usersToDelete.removeAll(newUsers);
        //get set of users to be added
        Set<User> usersToAdd = allUsers.clone();
        usersToAdd.removeAll(oldUsers);
        //getting Ids of users to delete/to add

        List<Voting_Campaign_Role__c> usersToAddRoles = new List<Voting_Campaign_Role__c>();
        for(User user: usersToAdd){
            Voting_Campaign_Role__c role = new Voting_Campaign_Role__c();
            role.RecordTypeId = Schema.SObjectType.Voting_Campaign_Role__c.getRecordTypeInfosByName().get(recordTp).getRecordTypeId();
            role.User__c = user.Id;
            role.Voting_Compaign__c = cmpID;
            usersToAddRoles.add(role);
        }
        //inserting new
        insert usersToAddRoles;
        //deleting old
        Set<Id> usersToDeleteIds = (new Map<Id, User>(new List<User>(usersToDelete))).keyset();
        delete [SELECT Id, User__c, Voting_Compaign__c
                FROM Voting_Campaign_Role__c 
                WHERE Voting_Compaign__c = :cmpID 
                AND User__c IN :usersToDeleteIds];
    }
}
