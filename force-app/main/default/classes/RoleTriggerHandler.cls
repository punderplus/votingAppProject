/**
 * handling functionality to call on different actions on Voting_Campaign_Role__c object 
 */ 
public with sharing class RoleTriggerHandler extends CustomMDTTriggerHandler{
    public List<Voting_Campaign_Role__c> newRoles = new List<Voting_Campaign_Role__c>();
    public List<Voting_Campaign_Role__c> oldRoles = new List<Voting_Campaign_Role__c>();
    
    /**
     * @description constructor with arguments for RoleTriggerHandler object
     * @param  newR list of new(basically Trigger.new) Voting_Campaign_Role__c objects
     * @param  oldR list of old(basically Trigger.old) Voting_Campaign_Role__c objects
     */ 
    public RoleTriggerHandler(List<Voting_Campaign_Role__c> newR, List<Voting_Campaign_Role__c> oldR){
        this.newRoles = newR;
        this.oldRoles = oldR;

    }
    /** 
     * @description default constructor for RoleTriggerHandler object 
     * @return   return description
     */ 
    public RoleTriggerHandler(){
        this((List<Voting_Campaign_Role__c>)Trigger.new, (List<Voting_Campaign_Role__c>)Trigger.old);
    }
    /**
     * @description invoked after Voting_Campaign_Role__c object(list of objects) is inserted
     * Invokes method to insert members in public groups
     */ 
    public override void afterInsert(){
        RoleSynchronizator_Queueable rsQ = new RoleSynchronizator_Queueable(newRoles);
        System.enqueueJob(rsQ);
    }
    /**
     * @description invoked after Voting_Campaign_Role__c object(list of objects) is deleted
     * Invokes method to delete members from public group
     */ 
    public override void afterDelete(){
        RoleDeleter_Queueable rdQ = new RoleDeleter_Queueable(oldRoles);
        System.enqueueJob(rdQ);
    }
}
