/**
 * handling functionality to call on different actions on Voting Campaign object 
 */ 
public with sharing class CampaignTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign__c> newCampaigns = new List<Voting_Campaign__c>();
    public List<Voting_Campaign__c> oldCampaigns = new List<Voting_Campaign__c>();
    /**
     * @description constructor with arguments for CampaignTriggerHandler object
     * @param  newCampaigns newCampaigns list of new(basically Trigger.new) Voting Campaign objects
     * @param  oldCampaigns oldCampaigns list of old(basically Trigger.old) Voting Campaign objects
     */ 
    public CampaignTriggerHandler(List<Voting_Campaign__c> newCampaigns, List<Voting_Campaign__c> oldCampaigns){
        this.newCampaigns = newCampaigns;
        this.oldCampaigns = oldCampaigns;
    }
    /**
     * @description default constructor for CampaignTriggerHandler object 
     * @return   return description
     */ 
    public CampaignTriggerHandler(){
        this((List<Voting_Campaign__c>)Trigger.new, (List<Voting_Campaign__c>)Trigger.old);
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is inserted
     * Invokes method to create public groups for campaigns
     */ 
    public override void afterInsert(){
        CampaignManager.createGroups(newCampaigns);
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is deleted
     * Invokes method to delete public groups attached campaigns
     */ 
    public override void afterDelete(){
        CampaignManager.deleteGroups(oldCampaigns);
    }
}
