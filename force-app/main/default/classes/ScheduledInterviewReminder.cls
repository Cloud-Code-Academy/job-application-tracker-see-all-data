/**
 * ScheduledInterviewReminder Trigger
 * Purpose: This is a schedulable class intended to be executed at specified times (e.g., daily) 
 * to check for any interviews scheduled for the next day and send reminders accordingly.
 */
global class ScheduledInterviewReminder implements Schedulable {
    
    /**
     * Executes the scheduled job.
     * @param SC - Context in which this job is being executed. Provides methods to get the job ID.
     */
    global void execute(SchedulableContext SC) {
        // Fetch interviews that are scheduled for tomorrow
        List<Event> interviews = InterviewReminder.getTomorrowsInterviews();

        // Check if there are any interviews found
        if(interviews.size() > 0) {
            // Send email reminders for the found interviews
            InterviewReminder.sendEmailReminders(interviews);
        }
    }
}
