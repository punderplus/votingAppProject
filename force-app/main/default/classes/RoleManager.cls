public class RoleManager {

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

    public String getGroupAutoNumber(Voting_Campaign_Role__c role){
        Voting_Campaign__c pgNumber = [SELECT Id, Voting_Campaign_Number__c FROM Voting_Campaign__c WHERE Id = :role.Voting_Compaign__c];
        return pgNumber.Voting_Campaign_Number__c + '';
    }
}
