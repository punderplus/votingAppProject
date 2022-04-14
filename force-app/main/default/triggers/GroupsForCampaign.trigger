trigger GroupsForCampaign on Voting_Campaign__c (after insert) {
    for(Voting_Campaign__c vc : Trigger.new){
        CampaignManager.GroupCreating(vc);
    }

}