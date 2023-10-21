@isTest
public class TakeHomeCalculationTest {
    @isTest static void testTakeHomeCalculations() {
        // Prepare a list of sample salaries to test different tax brackets
        List<Decimal> salaries = new List<Decimal>{
            13000,   // Taxable Income: -8350 (this will still fall under the 10% bracket after deduction)
            25000,   // Taxable Income: 11150 (12% bracket)
            60000,   // Taxable Income: 46150 (22% bracket)
            190000,  // Taxable Income: 176150 (24% bracket)
            220000,  // Taxable Income: 206150 (32% bracket)
            600000,  // Taxable Income: 586150 (35% bracket)
            650000   // Taxable Income: 636150 (37% bracket)
        };

        // Create and insert test Job_Application__c records for each sample salary
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        for (Decimal salary : salaries) {
            Job_Application__c jobApp = new Job_Application__c(Salary__c = salary);
            jobApplications.add(jobApp);
        }
        insert jobApplications;

        // Call the TakeHomeCalculations class method
        TakeHomeCalculations.calculateLiabilities(jobApplications);

        // Query the updated Job_Application__c records
        List<Job_Application__c> updatedJobApps = [SELECT Salary__c, 
                                                   Social_Security_Tax_Yearly__c, Social_Security_Tax_Monthly__c,
                                                   Medicare_Withholding_Yearly__c, Medicare_Withholding_Monthly__c, 
                                                   Federal_Income_Tax_Yearly__c, Federal_Income_Tax_Monthly__c,
                                                   Yearly_Take_home_Pay__c, Monthly_Take_home_Pay__c
                                                   FROM Job_Application__c WHERE Id IN :jobApplications];

        for (Job_Application__c updatedJobApp : updatedJobApps) {
            // Assertions to validate the calculations
            System.assertEquals(updatedJobApp.Salary__c * 0.062, updatedJobApp.Social_Security_Tax_Yearly__c);
            System.assertEquals(updatedJobApp.Social_Security_Tax_Yearly__c / 12, updatedJobApp.Social_Security_Tax_Monthly__c);

            System.assertEquals(updatedJobApp.Salary__c * 0.0145, updatedJobApp.Medicare_Withholding_Yearly__c);
            System.assertEquals(updatedJobApp.Medicare_Withholding_Yearly__c / 12, updatedJobApp.Medicare_Withholding_Monthly__c);

            System.assertEquals(updatedJobApp.Federal_Income_Tax_Yearly__c / 12, updatedJobApp.Federal_Income_Tax_Monthly__c);
        }
    }
}
