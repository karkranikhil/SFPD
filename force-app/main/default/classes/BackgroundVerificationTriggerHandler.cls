public class BackgroundVerificationTriggerHandler {
	public static void backgroundVerificationCheck(List<Background_Verification_Tasks__c > mNewBackgroundVerification){
        Integer flag = 0;
        Id conId = null;
        for(Background_Verification_Tasks__c bv : mNewBackgroundVerification){
            List<Background_Verification_Tasks__c> newBv = [select Contact__c,Application__c from Background_Verification_Tasks__c where id = :bv.id];
            conId = newBv[0].Application__c;
			List<ApplicationForm__c > lApplication = [select Id,Name, (select Status__c from Background_Verification_Tasks__r) from ApplicationForm__c where Id = :newBv[0].Contact__c];
            for(Background_Verification_Tasks__c temp : lApplication[0].Background_Verification_Tasks__r){
                if(temp.Status__c == 'Pending'){
                    flag = 1;
                }
			}
        } 
        if(flag == 0){
            ApplicationForm__c app = new ApplicationForm__c();
            app.Id = conId;
            app.Application_Status__c  = 'On Hold';
            update app;
        }
    }
}