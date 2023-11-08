/**
 *Query for interviews scheduled for the next weekday and send email reminders to the Interview (event) owner.
 */
public class InterviewReminder {

    public static List<Event> getTomorrowsInterviews() {
        // Calculate start and end of tomorrow's date to identify any interviews(events) are scheduled for tomorrow
        DateTime startOfTomorrow = DateTime.newInstance(Date.today().addDays(1), Time.newInstance(0, 0, 0, 0));
        DateTime endOfTomorrow = DateTime.newInstance(Date.today().addDays(1), Time.newInstance(23, 59, 59, 0));
        
        // SOQL Query to search for events with the "interview" type scheduled for tomorrow 
        List<Event> interviews = [SELECT Id, Subject, StartDateTime, EndDateTime, Location, OwnerId
                                  FROM Event 
                                  WHERE StartDateTime >= :startOfTomorrow 
                                  AND StartDateTime <= :endOfTomorrow 
                                  AND Type = 'Interview'];

        return interviews;
    }

    /**
     * Sends email reminders to the interview (event) owner that they have a scheduled interview tomorrow
     */
    public static void sendEmailReminders(List<Event> interviews) {
        // List to hold the email messages to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        // Store unique OwnerIds of the interviews
        Set<Id> ownerIds = new Set<Id>();
        for(Event interview : interviews) {
            ownerIds.add(interview.OwnerId);
        }

        // SOQL Query to retrieve details of users based on the OwnerIds
        Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN :ownerIds]);

        // Get the base URL of Salesforce org
        String baseURL = Url.getSalesforceBaseUrl().toExternalForm();

        // Loop through the interviews to prepare email messages
        for(Event interview : interviews) {
            User eventOwner = usersMap.get(interview.OwnerId);
            
            // Check if the event owner exists and has an email address
            if(eventOwner != null && eventOwner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {eventOwner.Email});
                mail.setSubject('Interview Reminder');
            
                String interviewee = (eventOwner != null) ? eventOwner.Name : 'N/A';

                // Prepare the body of the email with interview details and concatenate the base salesforce url with the interview Id
                String body = 'Hello ' + interviewee + ',\n\n' + 
                              'This is a reminder about the interview scheduled at ' + interview.StartDateTime.format() + ' to ' + interview.EndDateTime.format() + '.\n\n' +
                              'For more details, view the interview: (' + baseURL + '/' + interview.Id + ').';
                mail.setPlainTextBody(body);

                // Add the email to the emails list
                emails.add(mail);
            }
        }

        // If there are any emails to send, attempt to send them
        if(emails.size() > 0) {
            Messaging.sendEmail(emails);
        }
    }
}