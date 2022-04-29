/**
 * @description trigger on location
 */ 
trigger LocationTrigger on Voting_Location__c (after insert) {
    /**
     * @description invoking trigger handler
     */ 
    new CustomMDTTriggerHandler().run();
}