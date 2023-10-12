@IsTest public with sharing class EventTriggerTest {
    @isTest static void testEventTrigger(){
       List<Event> eventsToInsert = new List<Event>();
        for(Integer i = 0; i < 200; i++){
            Event eve = new Event(Subject = 'Test Event' + i,
            StartDateTime = System.now(),
            DurationInMinutes = 30);
            eventsToInsert.add(eve);
        }
       insert eventsToInsert;
       List<Event> eveTriggerValidation = new List<Event>();
       List<Event> eveNotTriggerValidation = new List<Event>();
       for(Integer i = 0; i < 200; i++){
        if(Math.mod(i,2) == 0){
            eventsToInsert[i].StartDateTime = System.now();
            eveTriggerValidation.add(eventsToInsert[i]);
       }else{
            eventsToInsert[i].StartDateTime = System.now().addDays(1);
            eveNotTriggerValidation.add(eventsToInsert[i]);
            }
        }
        test.startTest();
        try{
        update eventsToInsert;
        System.assert(false,'Expected an exception but did not get one.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('You cannot schedule two meetings at the same time.')); 
        }
        update eveNotTriggerValidation;
        List<Event> eveNotTriggerValidationUpdated = [SELECT Id, Subject, StartDateTime, DurationInMinutes FROM Event WHERE Id IN :eveNotTriggerValidation];
        for(Event eve : eveNotTriggerValidationUpdated){
            System.assertEquals(200, eveNotTriggerValidationUpdated.size(),'The number of events is not 200');
        }
        test.stopTest(); 
    }  
}