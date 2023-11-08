@isTest public with sharing class EventTriggerTest {
    @isTest static void doubleBookEvent(){
       List<Event> eventsToInsert = new List<Event>();
        for(Integer i = 0; i < 200; i++){
            Event eve = new Event(Subject = 'Test Event' + i,
            StartDateTime = System.now(),
            DurationInMinutes = 30);
            eventsToInsert.add(eve);

            Event eve1 = new Event(Subject = 'Test Event' + i,
            StartDateTime = System.now(),
            DurationInMinutes = 30);
            eventsToInsert.add(eve1);
        } 
        try{
        Test.startTest();
        insert eventsToInsert;
        }
        catch(DmlException e){
        System.assert(e.getMessage().contains(event.Type + 's' +' '+ 'cannot be scheduled on weekends.'));
        }
        Test.stopTest();
    }
    @isTest static void bookOnWeekends(){
        List<Event> weekends = new List<Event>();
        for(Integer i = 0; i < 200; i++){
            Event satBookings = new Event(Subject = 'Test Event' + i,
            StartDateTime = DateTime.newInstanceGMT(2023, 10, 20, 8, 0, 0),
            DurationInMinutes = 30);
            weekends.add(satBookings);
            Event sunBookings = new Event(Subject = 'Test Event' + i,
            StartDateTime = DateTime.newInstanceGMT(2023, 10, 22, 8, 0, 0),
            DurationInMinutes = 30);
            weekends.add(sunBookings);
        }
        try{
        Test.startTest();
        insert weekends;
        }
        catch(DmlException e){
        System.assert(e.getMessage().contains('This event slot is already booked.'));
        }
        Test.stopTest();
    }
}
    
