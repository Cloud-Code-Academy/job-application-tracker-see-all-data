global class ScheduledInterviewReminder implements Schedulable {
    global void execute(SchedulableContext SC) {
        List<Event> interviews = InterviewReminder.getTomorrowsInterviews();
        if(interviews.size() > 0) {
            InterviewReminder.sendEmailReminders(interviews);
        }
    }
}
