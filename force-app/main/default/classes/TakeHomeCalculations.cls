public class TakeHomeCalculations {

    public static void calculateLiabilities(List<Job_Application__c> jobApps) {
        for(Job_Application__c jobApp : jobApps) {
            if(jobApp.Salary__c != null) {
                // Social Security Yearly and Monthly
                jobApp.Social_Security_Tax_Yearly__c = jobApp.Salary__c * 0.062;
                jobApp.Social_Security_Tax_Monthly__c = jobApp.Social_Security_Tax_Yearly__c / 12;

                // Medicare Withholding Yearly and Monthly
                jobApp.Medicare_Withholding_Yearly__c = jobApp.Salary__c * 0.0145;
                jobApp.Medicare_Withholding_Monthly__c = jobApp.Medicare_Withholding_Yearly__c / 12;

                // Calculating Federal Income Tax based on brackets for 'Single' (Yearly)
                Double taxableIncome = jobApp.Salary__c - 13850; // Using 2023's Standard Deduction for 'Single'
                if(taxableIncome <= 11000) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.10;
                } else if(taxableIncome <= 44725) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.12;
                } else if(taxableIncome <= 95375) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.22;
                } else if(taxableIncome <= 182100) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.24;
                } else if(taxableIncome <= 231250) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.32;
                } else if(taxableIncome <= 578125) {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.35;
                } else {
                    jobApp.Federal_Income_Tax_Yearly__c = taxableIncome * 0.37;
                }

                // Calculating Federal Income Tax Monthly
                jobApp.Federal_Income_Tax_Monthly__c = jobApp.Federal_Income_Tax_Yearly__c / 12;

                // Calculating Yearly and Monthly Take-home Pay
                jobApp.Yearly_Take_home_Pay__c = jobApp.Salary__c - 
                    (jobApp.Social_Security_Tax_Yearly__c + jobApp.Medicare_Withholding_Yearly__c + jobApp.Federal_Income_Tax_Yearly__c);
                jobApp.Monthly_Take_home_Pay__c = jobApp.Yearly_Take_home_Pay__c / 12;
            }
        }
    }
}
