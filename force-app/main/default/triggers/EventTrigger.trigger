trigger EventTrigger on Event (before insert) {
//Create code validation to stop double-booking (scheduling two meetings simultaneously) or scheduling meetings on the weekend. The automation should be on the Salesforce standard event object so that interview events cannot be scheduled at the same time.
// Easy: Check if an existing event has the exact same start date/time. Don’t check the end date/time.
if(Trigger.isBefore && Trigger.isInsert){
    Set<Id> eventIds = new Set<Id>();
    for(Event doubleBook : Trigger.new){
        eventIds.add(doubleBook.Id);
    }
    List<Event> events = [SELECT Id, StartDateTime FROM Event WHERE Id IN :eventIds];
    for(Event doubleBook : Trigger.new){
        for(Event event : events){
            if(doubleBook.StartDateTime == event.StartDateTime){
                doubleBook.addError('You cannot schedule two meetings at the same time.');
            }
        }
    }
    for(Event NoBookOnWeekend : Trigger.new){
        if(NoBookOnWeekend.StartDateTime.format('EEEE') == 'Saturday' || NoBookOnWeekend.StartDateTime.format('EEEE') == 'Sunday'){
           NoBookOnWeekend.addError('You cannot schedule meetings on the weekend.');
        }
    }
}
}