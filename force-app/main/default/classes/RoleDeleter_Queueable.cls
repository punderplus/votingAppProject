/**
 * Queueable class for asynchronous delete of GroupMember objects for Role Trigger
 */ 
public with sharing class RoleDeleter_Queueable implements Queueable{
    //List of old Role objects
    private List<Voting_Campaign_Role__c> oldRoles;
    /**
     * @description constructor 
     * @param  newRoles - list of Role objects
     */ 
    public RoleDeleter_Queueable(List<Voting_Campaign_Role__c> oldR){
        this.oldRoles = oldR;
    }
    /**
     * @description method for on delete trigger to delete groups when Role object is deleted
     * @param  QueueableContext context
     */ 
    public void execute(QueueableContext context){
        Voting_Campaign_Role__c infoRole = oldRoles[0].clone();
        //getting info using ne of deleted Role objects
        RoleManager rm = new RoleManager();
        String pgType = rm.getGroupName([SELECT Id, Name FROM RecordType WHERE Id = :infoRole.RecordTypeId LIMIT 1].Name);
        String pgNumber = rm.getGroupAutoNumber(infoRole);
        String groupName = 'CMP' + '_' + pgNumber + '_' + pgType;
        //getting Group to delete GroupMember from
        Group cmpGroup = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = :groupName LIMIT 1];
        //getting ids of GroupMember objects to delete
        List<Id> gmIds = new List<Id>();
        for(Voting_Campaign_Role__c role: oldRoles){
            gmIds.add(role.User__c);
        }
        //getting list
        List<GroupMember> gmsToDelete = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId = :cmpGroup.ID AND UserOrGroupId IN :gmIds];
        //System.debug(gms);
        delete gmsToDelete;
    }
}