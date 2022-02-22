trigger BackgroundVerificationTrigger on Background_Verification_Tasks__c (after update) {
	if(trigger.isAfter && trigger.isUpdate){
     	//BackgroundVerificationTriggerHandler.backgroundVerificationCheck(Trigger.new);   
    }
}