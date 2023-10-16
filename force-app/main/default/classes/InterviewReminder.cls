public class InterviewReminder {

    public static List<Event> getTomorrowsInterviews() {
        Date tomorrow = Date.today().addDays(1);
      
        List<Event> interviews = [SELECT Id, Subject, StartDateTime, EndDateTime, Location, OwnerId
                                  FROM Event 
                                  WHERE StartDateTime = :tomorrow AND Type = 'Interview'];
        return interviews;
    }
    
    public static void sendEmailReminders(List<Event> interviews) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        Set<Id> ownerIds = new Set<Id>();
        for(Event interview : interviews) {
            ownerIds.add(interview.OwnerId);
        }

        // Query the User names and emails based on the OwnerIds
        Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN :ownerIds]);

        String baseURL = Url.getSalesforceBaseUrl().toExternalForm();

        for(Event interview : interviews) {
            User eventOwner = usersMap.get(interview.OwnerId);
            
            if(eventOwner != null && eventOwner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {eventOwner.Email});
                mail.setSubject('Interview Reminder');
            
                String interviewee = (eventOwner != null) ? eventOwner.Name : 'N/A';
            
                String body = 'Hello ' + interviewee + ',\n\n' + 
                              'This is a reminder about the interview scheduled at ' + interview.StartDateTime.format() + ' to ' + interview.EndDateTime.format() + '.\n\n' +
                              'For more details, view the interview: (' + baseURL + '/' + interview.Id + ').';
                mail.setPlainTextBody(body);
                emails.add(mail);
            }
        }

        if(emails.size() > 0) {
            Messaging.sendEmail(emails);
        }
    }
}
