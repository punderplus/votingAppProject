public with sharing class CampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign__c> newCampaings = new List<Voting_Campaign__c>();
    public List<Voting_Campaign__c> oldCampaings = new List<Voting_Campaign__c>();
    
    public CampaignTriggerHandler(List<Voting_Campaign__c> newCampaings, List<Voting_Campaign__c> oldCampaings){
        this.newCampaings = newCampaings;
        this.oldCampaings = oldCampaings;
    }

    public CampaignTriggerHandler(){
        this((List<Voting_Campaign__c>)Trigger.new, (List<Voting_Campaign__c>)Trigger.old);
    }
    public override void afterInsert(){
        for(Voting_Campaign__c vc : newCampaings){
            CampaignManager.GroupCreating(vc);
        }
    }
    public override void afterDelete(){
        for(Voting_Campaign__c vc : oldCampaings){
            CampaignManager.GroupDeletion(vc);
        }
    }
}
