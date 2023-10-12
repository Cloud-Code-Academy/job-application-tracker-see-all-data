trigger EventTrigger on Event (before insert) {
   EventTriggerHandler handler = new EventTriggerHandler();
    handler.run();
}