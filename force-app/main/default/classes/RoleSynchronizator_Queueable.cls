/**
 * Queueable class for asynchronous insert of GroupMember objects for Role Trigger
 */ 
public with sharing class RoleSynchronizator_Queueable implements Queueable{
    //List of new Role objects
    private List<Voting_Campaign_Role__c> newRoles;
    /**
     * @description constructor 
     * @param  newRoles - list of Role objects
     */ 
    public RoleSynchronizator_Queueable(List<Voting_Campaign_Role__c> newR){
        this.newRoles = newR;
    }
    /**
     * @description inserting group members
     * @param  context QueueableContext object
     */ 
    public void execute(QueueableContext context){
        Voting_Campaign_Role__c infoRole = newRoles[0].clone();
        RoleManager rm = new RoleManager();
        String pgType = rm.getGroupName([SELECT Id, Name FROM RecordType WHERE Id = :infoRole.RecordTypeId LIMIT 1].Name);
        String pgNumber = rm.getGroupAutoNumber(infoRole);
        String groupName = 'CMP' + '_' + pgNumber + '_' + pgType;
        Group cmpGroup = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName = :groupName LIMIT 1];
        List<GroupMember> gms = new List<GroupMember>();
        for(Voting_Campaign_Role__c role: newRoles){
            gms.add(new GroupMember(GroupId=cmpGroup.Id, UserOrGroupId=role.User__c));
        }
        //System.debug(gms);
        insert gms;
        System.enqueueJob(new CampaignSharing_Queueable(newRoles));
    }
}
