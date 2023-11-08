/**
 This is a schedulable apex class that will check for any interviews(events) scheduled for the following day (during the week)
  and send reminders accordingly. It is intended to be run through Salesforce Scheduled Jobs and should not look for interviews scheduled on weekends
  as there is validation to prevent scheduling interviews(events) on weekends.
 */
global class ScheduledInterviewReminder implements Schedulable {
    
   
    global void execute(SchedulableContext SC) {
        //List of interviews(events with the interview type) that are scheduled the next weekday, excluding weekends.
        List<Event> interviews = InterviewReminder.getTomorrowsInterviews();

        // Check to see if there are any interviews found. If found, send email reminder.
        if (!interviews.isEmpty()) {
            InterviewReminder.sendEmailReminders(interviews);
        }
    }
}