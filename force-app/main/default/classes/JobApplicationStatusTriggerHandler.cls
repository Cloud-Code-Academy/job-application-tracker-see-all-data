public with sharing class JobApplicationStatusTriggerHandler {
    
    public static void handleAfterUpdate(List<Job_Application__c> newList, Map<Id, Job_Application__c> oldMap) {
        List<Task> tasksToInsert = new List<Task>();
        Id currentUserId = UserInfo.getUserId();

        for (Job_Application__c app : newList) {
            Job_Application__c oldApp = oldMap.get(app.Id);

            if (oldApp.Status__c != app.Status__c) { 
                tasksToInsert.addAll(getTasksForStatus(app.Status__c, app.Id, currentUserId));

            }
        }

        if (!tasksToInsert.isEmpty()) {
            try {
                insert tasksToInsert;
            } catch (DmlException e) {
                 System.debug('Failed to insert tasks due to: ' + e.getMessage());
            }
        }
    }

    private static List<Task> getTasksForStatus(String status, Id applicationId, Id currentUserId) {
        List<Task> tasks = new List<Task>();

        if (status == 'Saved') {
            tasks.add(new Task(
                Description = '1. Does this job description align with your interests and values?\n' +
                              '2. Review the highlighted skills to see if the role is a good fit.\n' +
                              '3. Research the company or role and mark your excitement level.',
                Subject = 'Job Application was set to "Saved". Please see the Comments',
                WhatId = applicationId,
                OwnerId = currentUserId,
                ActivityDate = Date.today().addDays(2),
                Priority = 'Medium'
            ));
           
        } else if (status == 'Applying') {
           tasks.add(new Task(
            Description ='1. Find and research someone who works at the company and add them as a contact\n' +
                         '2. Set up an informational interview to learn more about the role/company\n' +
                         '3. Identify potential referrals to help get your application on the top of the pile\n'+ 
                         '4. Customize your work achievements using the job description keywords\n' + 
                         '5. Submit your application on the company website if possible',
             Subject = 'Job Application was set to "Applying". Please see the Comments',
             WhatId = applicationId,
             OwnerId = currentUserId,
             ActivityDate = Date.today().addDays(7),
             Priority = 'Medium'
           ));

        }  else if (status == 'Applied') {
            tasks.add(new Task(
                Description ='1. Reach out to the hiring manager or recruiter\n' +
                             '2. Follow up on your application via email weekly\n' +
                             '3. Continue identifying and saving similar job opportunities\n'+ 
                             '4. Set up weekly networking calls to explore similar companies/roles',
                 Subject = 'Job Application was set to "Applied". Please see the Comments',
                 WhatId = applicationId,
                 OwnerId = currentUserId,
                 ActivityDate = Date.today().addDays(7),
                 Priority = 'Medium'
               ));

            } else if (status == 'Interviewing') {
                tasks.add(new Task(
                    Description ='1. Prepare your blurb or “tell me about yourself” response\n' +
                                 '2. Practice answering behavioral interview questions\n' +
                                 '3. Research the company and your interviewers\n'+ 
                                 '4. Set up your virtual interview space and test your tech\n' +
                                  '5. Send thank you emails within 24 hours',
                     Subject = 'Job Application was set to "Interviewing". Please see the Comments',
                     WhatId = applicationId,
                     OwnerId = currentUserId,
                     ActivityDate = Date.today().addDays(5),
                     Priority = 'Medium'
                   ));
            } else if (status == 'Negotiating') {
                tasks.add(new Task(
                    Description ='1. Research your market value and know your numbers\n' +
                                 '2. Prepare your negotiation scripts\n' +
                                 '3. Evaluate your offer and decline or accept',
                     Subject = 'Job Application was set to "Negotiating". Please see the Comments',
                     WhatId = applicationId,
                     OwnerId = currentUserId,
                     ActivityDate = Date.today().addDays(3),
                     Priority = 'Medium'
                   ));
            } else if (status == 'Accepted') {
                tasks.add(new Task(
                    Description ='1. Plan your resignation if applicable\n' +
                                 '2. Take some time to relax and recharge\n' +
                                 '3. Prepare for your first day of onboarding',
                     Subject = 'Job Application was set to "Accepted". Please see the Comments',
                     WhatId = applicationId,
                     OwnerId = currentUserId,
                     ActivityDate = Date.today().addDays(7),
                     Priority = 'Medium'
                   ));
            } else if (status == 'Closed') {
                tasks.add(new Task(
                    Description ='1. Send a follow-up email thanking the interviewer and asking for feedback\n' +
                                 '2. Review your notes and reflect on areas of improvement',
                     Subject = 'Job Application was set to "Closed". Please see the Comments',
                     WhatId = applicationId,
                     OwnerId = currentUserId,
                     ActivityDate = Date.today().addDays(2),
                     Priority = 'Medium'
                   ));
            }

        return tasks;
    }
}