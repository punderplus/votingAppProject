public with sharing class CampaignSharing_Queueable implements Queueable{
    //List of new Role objects
    private List<Voting_Campaign_Role__c> newRoles;
    /**
     * @description constructor 
     * @param  newRoles - list of Role objects
     */ 
    public CampaignSharing_Queueable(List<Voting_Campaign_Role__c> newR){
        this.newRoles = newR;
    }
    /**
     * @description inserting group members
     * @param  context QueueableContext object
     */ 
    public void execute(QueueableContext context){
        List<Voting_Campaign__Share> cmpShrList = new List<Voting_Campaign__Share>();
        for(Voting_Campaign_Role__c role: newRoles){
            Voting_Campaign__Share cmpShr = new Voting_Campaign__Share();
            cmpShr.ParentId = role.Voting_Compaign__c;
            cmpShr.UserOrGroupId = role.User__c;
            cmpShr.AccessLevel = 'Read';
            cmpShrList.add(cmpShr);
        }        
        insert cmpShrList;
    }
}