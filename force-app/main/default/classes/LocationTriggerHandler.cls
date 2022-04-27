/**
 * trigger handler for location trigger
 */  
public with sharing class LocationTriggerHandler extends CustomMDTTriggerHandler{
    /**
     * @description new list of locations
     */ 
    public List<Voting_Location__c> newLocations = new List<Voting_Location__c>();
    /**
     * @description constuctor with arguements
     * @param  list of new locations
     */ 
    public LocationTriggerHandler(List<Voting_Location__c> newLocations){
        this.newLocations = newLocations;
    }
    /**
     * @description consturctor withour arguements
     */ 
    public LocationTriggerHandler(){
        this((List<Voting_Location__c>)Trigger.new);
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is inserted
     * Invokes method to get coords by address
     */ 
    public override void afterInsert(){
        LocationUtility_Queueable coordsCreator = new LocationUtility_Queueable(newLocations);
        System.enqueueJob(coordsCreator);
    }
}