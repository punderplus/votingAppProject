trigger CampaignTrigger on Voting_Campaign__c (after insert, after delete) {
    new CustomMDTTriggerHandler().run();
}