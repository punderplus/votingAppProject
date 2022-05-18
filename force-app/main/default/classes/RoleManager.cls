/**
 * Methods for Role Trigger
 */ 
public class RoleManager {
    /**
     * @description getting groupName Type from recordTp
     * @param  recordTp recordTypeId field of Role
     * @return  return name
     */ 
    public String getGroupName(String recordTp){
        switch on recordTp{
            when 'Moderator'{
                return 'MODER';
            }
            when 'Configurator'{
                return 'CONFG';
            }            
            when 'Voter'{
                return 'VOTER';
            }
            when 'Analytic'{
                return 'ANLTC';
            }      
        }
        return 'Error';
    }
    /**
     * @description getting role 
     * @param  role one of Role objects to get info from it
     * @return  return autoNumber field of Campaign
     */ 
    public String getGroupAutoNumber(Voting_Campaign_Role__c role){
        Voting_Campaign__c pgNumber = [SELECT Id, Voting_Campaign_Number__c FROM Voting_Campaign__c WHERE Id = :role.Voting_Compaign__c];
        return pgNumber.Voting_Campaign_Number__c + '';
    }
}
