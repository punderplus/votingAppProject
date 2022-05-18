/**
 * @description Voting_Campaign_Role__c description
 * @param  insert do some stuff after record insert
 * @param  delete do some stuff after record delete
 */ 
trigger RoleTrigger on Voting_Campaign_Role__c (after insert, after delete) {
    /**
     * @description invoking trigger handler
     */ 
    new CustomMDTTriggerHandler().run();
}