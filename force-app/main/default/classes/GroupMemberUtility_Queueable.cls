/**
 * queueable class which implements asynchronous jobs for GroupMember object
 */ 
public with sharing class GroupMemberUtility_Queueable implements Queueable {

    private List<Group> newGroups;
    /**
     * @description constructor 
     * @param  newGroups - list of groups related to Voting Campaign object
     */ 
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
        //dmlexception handler and sending message to creator email
        try{
            insert gms;
        }catch(DmlException error){
            //error handled through exception utility class(email to admin and user who made insert)
            ExceptionUtility eu = new ExceptionUtility(error);
            System.enqueueJob(eu);
        }
    }
}
