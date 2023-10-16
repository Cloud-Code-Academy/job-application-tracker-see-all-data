public with sharing class EventTriggerHandler extends TriggerHandler{
    private List<Event> newEvents;
    public EventTriggerHandler() {
        this.newEvents = (List<Event>) Trigger.new;

    }
    public override void beforeInsert() {
        List<Event> events = new List<Event>();
        
        for(Event event : this.newEvents){
            if(event.StartDateTime.format('EEEE') == 'Saturday' || event.StartDateTime.format('EEEE') == 'Sunday'){
               event.addError('Interviews cannot be scheduled on weekends');
            } else {
                events.add(event);
            }
        }
        for(Event event : events){
            eventDates.add(event.StartDateTime);
        }
        List<Event> existingEvents = [SELECT Id, StartDateTime FROM Event WHERE StartDateTime IN :eventDates];
        for(Event event : events){
            for(Event existingEvent : existingEvents){
                if(event.StartDateTime == existingEvent.StartDateTime){
                   event.addError('You cannot schedule two Interviews at the same time.');
                }
            }
        }


    }

}