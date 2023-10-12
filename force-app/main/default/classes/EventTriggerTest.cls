@IsTest public with sharing class EventTriggerTest {
    @isTest static void testEventTrigger(){
        List<Event> eventTest = new List<Event>();
        Event ev = new Event();
        ev.Subject = 'Test';
        ev.StartDateTime = System.now();  
        ev.DurationInMinutes = 30;
        eventTest.add(ev);
        
        Event ev2 = new Event();
        ev2.Subject = 'Test';
        ev2.StartDateTime = System.now();
        ev2.DurationInMinutes = 30;
        eventTest.add(ev2);
        List<Event> TestEvents = new List<Event>([SELECT Id, Subject, StartDateTime FROM Event WHERE Id IN :eventTest]);

        Test.startTest();
        insert eventTest;
        Test.stopTest();
        
        System.assertEquals(0, TestEvents.size(), 'Event was double booked');  
    }
    
}