//Set the primary contact on the job application if the primary contact is null and there is at least one related contact. Use the first contact available in the contact-related list or the first contact related to the Company(Account).

public class AutomatePrimaryContact {
    public static void assignPrimaryContact(List<Job_Application__c> jobApplicationsList) {
        List<Job_Application__c> jobAppList = new List<Job_Application__c>();

        Set<Id> accountIds = new Set<Id>();

        for(Job_Application__c jobApp : jobApplicationsList) {
        if (jobApp.Primary_Contact__c == null && jobApp.Company_Name__c != null){
            accountIds.add(jobApp.Company_Name__c);
        }
    }
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]){
            if(!accountToContactMap.containsKey(con.AccountId)){
                accountToContactMap.put(con.AccountId, con);
            }
        }

        for (Job_Application__c jobApp : jobApplicationsList){
            if (jobApp.Primary_Contact__c == null && jobApp.Company_Name__c != null){
                Contact relatedContact = accountToContactMap.get(jobApp.Company_Name__c);
                if(relatedContact != null){
                    jobApp.Primary_Contact__c = relatedContact.Id;
                    jobAppList.add(jobApp);
                }
            }
        }
    }
}