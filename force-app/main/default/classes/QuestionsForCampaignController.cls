//class for quizForm lwc containing methods to work with questions/answers
public class QuestionsForCampaignController {
    /**
     * @description getQuestions description
     * @param  cmpId id of campaign
     * @return  question for particular campaign
     */ 
    @AuraEnabled(cacheable=true)
    public static List<Voting_Question__c> getQuestions(Id cmpId){
        List<Voting_Question_to_Campaign__c> junctionList = [SELECT Id,Question__c FROM Voting_Question_to_Campaign__c 
                WHERE Voting_Compaign__c = :cmpId];
        List<Id> questionIds = new List<Id>();
        for(Voting_Question_to_Campaign__c question: junctionList){
            questionIds.add(question.Question__c);
        }
        //System.debug([SELECT Name, Question_Description__c FROM Voting_Question__c WHERE Id IN :questionIds]);
        return [SELECT Name, Question_Description__c FROM Voting_Question__c WHERE Id IN :questionIds];
    }

    /**
     * @description getAnswers getting all answers for all questions
     * @param  list of questions ids
     * @return  junctions between answers and options
     */ 
    @AuraEnabled(cacheable=true)
    public static List<Voting_Option_to_Question__c> getAnswers(List<Id> questionsList){
        System.debug('answers');
        System.debug(questionsList);
        System.debug([SELECT Question__c, Option__r.Name, Option__r.Option_Description__c FROM Voting_Option_to_Question__c WHERE Question__r.Id IN :questionsList]);
        return [SELECT Question__r.Id, Option__r.Name, Option__r.Option_Description__c 
                FROM Voting_Option_to_Question__c 
                WHERE Question__c 
                IN :questionsList];

    }

    /**
     * @description checks if user has already voted or no
     * @param  userId id of user
     * @param  cmpId  id of campaign
     * @return   return if he did or not
     */ 
    @AuraEnabled(cacheable=true)
    public static Boolean isVoted(Id userId, Id cmpId){
        if([SELECT count() FROM Voting_Vote__c WHERE OwnerId = :userId AND Voting_Compaign__c = :cmpId] == 0){
            return True;
        }else{
            return False;
        }
    }

    /**
     * @description checks if campaign in progress
     * @param  cmpId id of campaign
     * @return  return if it is or no
     */ 
    @AuraEnabled(cacheable=true)
    public static Boolean isInProgress(Id cmpId){
        if(([SELECT Id, Status__c FROM Voting_Campaign__c WHERE Id = :cmpId LIMIT 1]).Status__c == 'Launched'){
            return True;
        }else{
            return False;
        }
    }
}
