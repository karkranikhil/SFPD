trigger FamilyMemberTrigger on Family_Member__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        List<ApplicationForm__c > appList = new List<ApplicationForm__c >();
        for(Family_Member__c Fmember : Trigger.new){
            Id appId = Fmember.Application__c;
            ApplicationForm__c  app = new ApplicationForm__c ();
            app.Id = appId;
            app.Rating__c  = 0;
            appList.add(app);
        }
        update appList;
    }
}