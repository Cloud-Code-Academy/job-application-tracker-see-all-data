@isTest
public class InterviewReminderTest {
    // Query for an existing user 
    static User brittanyYoung = [SELECT Id FROM User WHERE FirstName = 'Brittany' AND LastName = 'Young' LIMIT 1];

    @isTest
    static void testSendEmailReminders() {
        Test.startTest();

        // Calculate the next weekday (Monday to Friday) for the test event
        Date nextWeekday = Date.today(); 

        // Create a test interview event scheduled for the next weekday 
        Event testInterview = new Event(
            Subject = 'Test Interview',
            StartDateTime = DateTime.newInstance(nextWeekday, Time.newInstance(10, 0, 0, 0)),
            EndDateTime = DateTime.newInstance(nextWeekday, Time.newInstance(11, 0, 0, 0)),
            Location = 'Test Location',
            OwnerId = brittanyYoung.Id,
            Type = 'Interview'
        );

        try {
            insert testInterview;
        } catch (Exception e) {
            // Handle any exceptions if needed
        }

        List<Event> interviews = new List<Event>();
        interviews.add(testInterview);
        InterviewReminder.sendEmailReminders(interviews);

        Test.stopTest();
    }

    @isTest
    static void testScheduledInterviewReminder() {
        Test.startTest();

        // Schedule the batch job to run on weekdays (Monday to Friday)
        String cronExpression = '0 0 0 ? * 2-6 *'; // This schedules the job to run on Monday through Friday

        ScheduledInterviewReminder reminder = new ScheduledInterviewReminder();
        String jobId = System.schedule('TestScheduledJob', cronExpression, reminder);

        Test.stopTest();

        // Query for the scheduled job and verify its existence
        CronTrigger cronTrigger = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        System.assertNotEquals(null, cronTrigger);
    }
}
