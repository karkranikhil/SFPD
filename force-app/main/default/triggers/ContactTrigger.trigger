trigger ContactTrigger on Contact (after update) {
    if(trigger.isAfter && trigger.isUpdate){
     // Below code moved to ApplicationFormTrigger as per change in data model.
     //	ContactTriggerHandler.backGroundCheck(Trigger.NewMap,Trigger.OldMap);   
    }
}