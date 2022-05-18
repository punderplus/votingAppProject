/**
 * @description trigger on Voting Campaign object
 * @param  insert - some tasks after insert
 * @param  delete - some tasks after delete
 */
trigger CampaignTrigger on Voting_Campaign__c (after insert, after delete) {
    /**
     * @description invoking trigger handler
     */ 
    new CustomMDTTriggerHandler().run();
}