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
            //System.debug('Error handled');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] address = new String[] {UserInfo.getUserEmail()};
            mail.setToAddresses(address);
            mail.setSenderDisplayName('Voting App support');
            mail.setSubject('Problem occured while data manipulation');
            mail.setPlainTextBody('Insert is not commited due to DmlException error: ' + error.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}
