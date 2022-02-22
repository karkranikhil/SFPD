trigger ApplicationFormTrigger on ApplicationForm__c (after update, before update,after insert) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            ApplicationFormTriggerHandler.backGroundCheck(Trigger.NewMap,Trigger.OldMap);
             ApplicationFormTriggerHandler.cleanSampleRecord(Trigger.NewMap);
            // ApplicationFormTriggerHandler.onHoldStatusTransition(Trigger.NewMap,Trigger.OldMap);
        }
        if(trigger.isInsert){
            ApplicationFormTriggerHandler.cleanSampleRecord(Trigger.NewMap);
           // ApplicationFormTriggerHandler.getRating(Trigger.new,Trigger.OldMap);
        } 
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        ApplicationFormTriggerHandler.getRating(Trigger.new,Trigger.OldMap); 
        ApplicationFormTriggerHandler.overallAppStatusUpdate(Trigger.NewMap);
        ApplicationFormTriggerHandler.ownerChange(Trigger.new,Trigger.OldMap);
    }
    
}