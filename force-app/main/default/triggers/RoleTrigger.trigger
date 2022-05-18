trigger RoleTrigger on Voting_Campaign_Role__c (after insert, after delete) {
    new CustomMDTTriggerHandler().run();
}