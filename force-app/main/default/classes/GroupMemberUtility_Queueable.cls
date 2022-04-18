public with sharing class GroupMemberUtility_Queueable implements Queueable {
    private List<Group> newGroups;

    public GroupMemberUtility_Queueable(List<Group> newGroups){
        this.newGroups = newGroups;
    }
    /**
     * @description assigns creator of campaign as a public confugurators group member
     * @param  context
     */ 
    public void execute(QueueableContext context) {
        List<GroupMember> gms = new List<GroupMember>();
        for (Group newGroup: newGroups){
            if (newGroup?.name?.contains('CONFG')){
                gms.add(new GroupMember(GroupId=newGroup.Id, UserOrGroupId=UserInfo.GetUserId()));
            }
        }
        insert gms;
    }
}
