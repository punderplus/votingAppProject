/**
 * contains methods for triggers on Voting Campaign object
 */
public with sharing class CampaignManager {
    /**
     * @description creates public groups for any campaign inserted
     * @param  addedCampaigns list of inserted campaigns
     */
    public static void createGroups(List<Voting_Campaign__c> addedCampaigns) {
        //list of roles
        String[] types = new List<String>{ '-CONFG', '-VOTER', '-MODER', '-ANLTC' };
        List<Voting_Campaign_Role__c> roles = new List<Voting_Campaign_Role__c>();
        //adding groups
        List<Group> groups = new List<Group>();
        for (Voting_Campaign__c vc : addedCampaigns) {
            roles.add(addRoleObject(vc));
            for (String s : types) {
              groups.add(new Group(Name = 'CMP-' + vc.Voting_Campaign_Number__c + s));
            }
        }
        //inserting roles objects
        insert roles;
        //inserting public groups
        insert groups;
        //Adding group creator as a configurator using Queueable class
    }
    /**
     * @description adds role object
     * @param  campaign for master-detail field
     * @return    return Role object
     */ 
    public static Voting_Campaign_Role__c addRoleObject(Voting_Campaign__c vc){
        Voting_Campaign_Role__c role = new Voting_Campaign_Role__c();
        role.RecordTypeId = Schema.SObjectType.Voting_Campaign_Role__c.getRecordTypeInfosByName().get('Configurator').getRecordTypeId();
        role.User__c = UserInfo.GetUserId();
        role.Voting_Compaign__c = vc.Id;
        return role;
    }

    /**
     * @description deletes public groups for any campaign deleted
     * @param  deletedCampaigns list of deleted campaigns
     */
    public static void deleteGroups(List<Voting_Campaign__c> deletedCampaigns) {
        List<String> filters = new List<String>();
        Set<Id> deletedCampaignsIds = (new Map<Id, SObject>(deletedCampaigns)).keySet();
        for (Voting_Campaign__c vc : deletedCampaigns) {
            filters.add('%' + vc.Voting_Campaign_Number__c + '%');
        }
        //deleting groups connected to campaign
        delete [SELECT ID, OwnerId, Name FROM Group WHERE Name LIKE :filters];
        //deleting Role objects connected to campaign
        delete [SELECT Id FROM Voting_Campaign_Role__c WHERE Voting_Compaign__c IN :deletedCampaignsIds];
    }
}
