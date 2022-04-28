/**
 * queueable class which implements asynchronous jobs for Voting Location object
 */ 
public with sharing class LocationUtility_Queueable implements Queueable, Database.AllowsCallouts {

    private List<Voting_Location__c> newLocations;
    /**
     * @description constructor 
     * @param  newGroups - list of groups related to Voting Location object
     */ 
    public LocationUtility_Queueable(List<Voting_Location__c> newLocations){
        this.newLocations = newLocations;
    }
    /**
     * @description for every new Location gets its coordinates by address using MakePostCallout method
     * @param  context
     */ 
    public void execute(QueueableContext context) {
        LocationCallout coordinator = new LocationCallout();
        List<Voting_Location__c> locations = new List<Voting_Location__c>();
        for(Voting_Location__c location: newLocations){
            Voting_Location__c updatedLocation = location.clone(true, false, false, false);
            updatedLocation = coordinator.makeGetCallout(updatedLocation);
            locations.add(updatedLocation);
        }
        //dmlexception handler and sending message to creator email
        try{
            update locations;
        }catch(DmlException error){
            //error handled through exception utility class(email to admin and user who made insert)
            ExceptionUtility eu = new ExceptionUtility(error);
            System.enqueueJob(eu);
        }
    }
}