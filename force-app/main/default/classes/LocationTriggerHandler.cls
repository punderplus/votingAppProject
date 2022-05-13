/**
 * trigger handler for location trigger
 */  
public with sharing class LocationTriggerHandler extends CustomMDTTriggerHandler{
    /**
     * @description new list of locations
     */ 
    public List<Voting_Location__c> locationsNew = new List<Voting_Location__c>();

    /**
     * @description constuctor with arguements
     * @param  list of new locations
     */ 
    public LocationTriggerHandler(List<Voting_Location__c> locationsList){
        this.locationsNew = locationsList;
    }
    /**
     * @description consturctor withour arguements
     */ 
    public LocationTriggerHandler(){
        this((List<Voting_Location__c>)Trigger.new);
    }
    /**
     * @description method to get locations to update
     * @param  list of changed records
     * @return  list of locations needed to be update
     */
    private List<Voting_Location__c> filterToUpdate(List<Voting_Location__c> newRecords){
        List<Voting_Location__c> locationsToUpdate = new List<Voting_Location__c>();
        for(Voting_Location__c newRecord: newRecords){
            Voting_Location__c oldRecord = (Voting_Location__c)Trigger.oldMap.get(newRecord.Id);
            if(newRecord.Country__c != oldRecord.Country__c ||
               newRecord.City__c != oldRecord.City__c ||
               newRecord.Address__c != oldRecord.Address__c){
                locationsToUpdate.add(newRecord);
            }
        }
        return locationsToUpdate;
    }
    /**
     * @description invoked after Voting_Campaign__c object(list of objects) is inserted
     * Invokes method to get coords by address
     */ 
    public override void afterInsert(){
        LocationUtility_Queueable coordsCreator = new LocationUtility_Queueable(locationsNew);
        System.enqueueJob(coordsCreator);
    }
    public override void afterUpdate(){
        List<Voting_Location__c> locationsToUpdate = filterToUpdate(locationsNew);
        if(locationsNew.size() > 0){
            LocationUtility_Queueable coordsCreator = new LocationUtility_Queueable(locationsNew);
            System.enqueueJob(coordsCreator);
        }
    }  
}