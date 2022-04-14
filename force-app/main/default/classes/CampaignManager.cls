public with sharing class CampaignManager{
    public static void GroupCreating(Voting_Campaign__c vc){
        List<Group> groups = new List<Group>();
        String[] types = new String[]{'-CONFG', '-VOTER', '-MODER', '-ANLTC'};
        for(String s: types){
            groups.add(new Group(Name='CMP-'+vc.Voting_Campaign_Number__c+s));
        }
        insert groups;
        CampaignManager.insertConf(groups[0].ID);
    }

    public static void GroupDeletion(Voting_Campaign__c vc){
        String checker = '%' + vc.Voting_Campaign_Number__c + '%';
        List<Group> groupsToDelete = [SELECT ID, OwnerId, Name FROM Group WHERE Name LIKE :checker];
        delete groupsToDelete;
    }  

    @future
    private static void insertConf(ID groupIdn){
        GroupMember gm = new GroupMember(GroupID=groupIdn, UserOrGroupId=UserInfo.getUserId());
        insert gm;
    }
}
