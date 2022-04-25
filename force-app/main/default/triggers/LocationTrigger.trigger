/**
 * @description trigger on location
 */ 
trigger LocationTrigger on Voting_Location__c (after insert) {
    new CustomMDTTriggerHandler().run();
}