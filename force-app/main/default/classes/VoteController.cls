/**
 * class to contol vote creation from quisForm lwc
 */ 
public class VoteController {
    @AuraEnabled
    /**
     * @description addVotes description
     * @param  userId id of voting user
     * @param  cmpId  id of voting campaign
     * @param  questionsAndAnswers list of questions and answers pairs
     */ 
    public static void addVotes(Id userId, Id cmpId, List<Object> questionsAndAnswers) {
        List<Voting_Vote__c> vvs = new List<Voting_Vote__c>();
        //System.debug(questionsAndAnswers);
        for(Object obj: questionsAndAnswers){
            Map<Object, Object> objMap = (Map<Object, Object>)obj;
            Voting_Vote__c vv = new Voting_Vote__c();
            vv.OwnerId = userId;
            vv.Question__c = (Id)objMap.get('question');
            vv.Voting_Compaign__c = cmpId;
            vv.Option__c = (Id)objMap.get('option');
            vvs.add(vv);
        }
        insert vvs;
    }
}
