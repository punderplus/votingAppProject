public with sharing class CampaignDeleteSharing_Queueable implements Queueable{
    //List of old Role objects
    private List<Voting_Campaign_Role__c> oldRoles;
    /**
     * @description constructor 
     * @param  oldRoles - list of Role objects
     */ 
    public CampaignDeleteSharing_Queueable(List<Voting_Campaign_Role__c> oldR){
        this.oldRoles = oldR;
    }
    /**
     * @description deleting sharing rules
     * @param  context QueueableContext object
     */ 
    public void execute(QueueableContext context){
        List<Id> parentIds = new List<Id>();
        List<Id> usersIds = new List<Id>();
        for(Voting_Campaign_Role__c role: oldRoles){
            parentIds.add(role.Voting_Compaign__c);
            usersIds.add(role.User__c);
        }
        List<Voting_Campaign__Share> cmpShrList = [SELECT ParentId, UserOrGroupId FROM Voting_Campaign__Share 
                                                   WHERE ParentId IN :parentIds AND UserOrGroupId IN :usersIds];
        delete cmpShrList;
    }
}