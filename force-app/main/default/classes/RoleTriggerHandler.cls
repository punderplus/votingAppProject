/**
 * handling functionality to call on different actions on Voting Campaign object 
 */ 
public with sharing class RoleTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign_Role__c> newRoles = new List<Voting_Campaign_Role__c>();
    public List<Voting_Campaign_Role__c> oldRoles = new List<Voting_Campaign_Role__c>();
    
    /**
     * @description constructor with arguments for CampaignTriggerHandler object
     * @param  newCampaigns newCampaigns list of new(basically Trigger.new) Voting Campaign objects
     * @param  oldCampaigns oldCampaigns list of old(basically Trigger.old) Voting Campaign objects
     */ 
    public RoleTriggerHandler(List<Voting_Campaign_Role__c> newR, List<Voting_Campaign_Role__c> oldR){
        this.newRoles = newR;
        this.oldRoles = oldR;

    }
    /** 
     * @description default constructor for CampaignTriggerHandler object 
     * @return   return description
     */ 
    public RoleTriggerHandler(){
        this((List<Voting_Campaign_Role__c>)Trigger.new, (List<Voting_Campaign_Role__c>)Trigger.old);
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is inserted
     * Invokes method to create public groups for campaigns
     */ 
    public override void afterInsert(){
        RoleSynchronizator_Queueable rsQ = new RoleSynchronizator_Queueable(newRoles);
        System.enqueueJob(rsQ);
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is deleted
     * Invokes method to delete public groups attached campaigns
     */ 
    public override void afterDelete(){

    }
}
