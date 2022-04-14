trigger GroupsForCampaignDelete on Voting_Campaign__c (after delete) {
    for(Voting_Campaign__c vc : Trigger.old){
        CampaignManager.GroupDeletion(vc);
    }
}