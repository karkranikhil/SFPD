public without sharing class ContactDashboardController {
    
    @AuraEnabled
    public static String fetchAllApplications(){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            Map<Id, ApplicationForm__c> applicationMap = new Map<Id, ApplicationForm__c>([Select Id,Is_Completed__c,Name,Application_Status__c,CreatedDate,Applying_For__c from ApplicationForm__c where Contact__c = :ContactId AND Application_Status__c != 'Pre-Qualification' AND Pre_qualification_Outcome__c ='Qualified' ORDER BY Name DESC]);
            List<vlocity_ins__OmniScriptInstance__c> instanceList = [SELECT ID,vlocity_ins__ResumeLink__c,vlocity_ins__ObjectId__c FROM vlocity_ins__OmniScriptInstance__c WHERE vlocity_ins__ObjectId__c IN :applicationMap.keySet()];
            Map<Id, vlocity_ins__OmniScriptInstance__c> newMap = new Map<Id, vlocity_ins__OmniScriptInstance__c>();
            List<ApplicationWrapper> wrapperList = new List<ApplicationWrapper>();
            for(vlocity_ins__OmniScriptInstance__c instance : instanceList){
                newMap.put(instance.vlocity_ins__ObjectId__c, instance);
                ApplicationWrapper wrapper = new ApplicationWrapper();
                wrapper.applicationId = instance.vlocity_ins__ObjectId__c;
                wrapper.applicationStatus = applicationMap.get(instance.vlocity_ins__ObjectId__c).Application_Status__c;
                wrapper.applicationCompleted = applicationMap.get(instance.vlocity_ins__ObjectId__c).Is_Completed__c;
                wrapper.resumeURL = instance.vlocity_ins__ResumeLink__c;
                wrapper.isResumeURL = applicationMap.get(instance.vlocity_ins__ObjectId__c).Is_Completed__c == true ? false : true;
                wrapper.applicationName = applicationMap.get(instance.vlocity_ins__ObjectId__c).Name;
                wrapper.isPreQualification = false;
                wrapper.applicationPosition = applicationMap.get(instance.vlocity_ins__ObjectId__c).Applying_For__c;
                wrapper.createdDate = date.newinstance(applicationMap.get(instance.vlocity_ins__ObjectId__c).CreatedDate.year(), applicationMap.get(instance.vlocity_ins__ObjectId__c).CreatedDate.month(), applicationMap.get(instance.vlocity_ins__ObjectId__c).CreatedDate.day()).format();
                wrapperList.add(wrapper);
            }
            
            for(ApplicationForm__c form : applicationMap.values()){
                if(!newMap.containsKey(form.Id)){
                    ApplicationWrapper wrapper = new ApplicationWrapper();
                    wrapper.applicationId = form.Id;
                    wrapper.applicationStatus = form.Application_Status__c;
                    //wrapper.applicationCompleted = form.Is_Completed__c;
                    wrapper.resumeURL = '';
                    wrapper.isResumeURL = false;
                    wrapper.applicationName = form.Name;
                    wrapper.isPreQualification = form.Is_Completed__c == false && form.Application_Status__c == 'Online Application' ? true : false;
                    wrapper.applicationCompleted = wrapper.isPreQualification  == true? false : true ;
                    wrapper.applicationPosition = form.Applying_For__c;
                    wrapper.createdDate = date.newinstance(form.CreatedDate.year(), form.CreatedDate.month(), form.CreatedDate.day()).format();
                    wrapperList.add(wrapper);
                }
                
            }
            System.debug('Sorted Result '+JSON.serialize(wrapperList));
           
            return JSON.serialize(wrapperList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    public class ApplicationWrapper{
        @AuraEnabled
        public string applicationId;
        @AuraEnabled
        public string applicationPosition;
        @AuraEnabled
        public String createdDate;
        @AuraEnabled
        public string applicationStatus;
        @AuraEnabled
        public Boolean applicationCompleted;
        @AuraEnabled
        public string resumeURL;
        @AuraEnabled
        public string applicationName;
        @AuraEnabled
        public Boolean isPreQualification;
        @AuraEnabled
        public Boolean isResumeURL;

    }
    @AuraEnabled
    public static void updateContact(string appId, string appStatus){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            List<Contact> contactsToUpdate = [SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1];
            for(Contact con: contactsToUpdate){
                con.Application_Id__c = appId;
                con.Application_Status__c = appStatus;
            }

            update contactsToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string getResumeURL(string appId){
        try {
            List<vlocity_ins__OmniScriptInstance__c> savedScripts = [
                SELECT Id, vlocity_ins__RelativeResumeLink__c FROM vlocity_ins__OmniScriptInstance__c WHERE vlocity_ins__ObjectId__c =: appId
            ];
            if(savedScripts.size()>0){
                return savedScripts[0].vlocity_ins__RelativeResumeLink__c;
            }
            return 'No recent Saved Omniscript with this appId';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String fetchCurrentApplication(){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            List<Contact> con = [
                SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1
                ];
            return con[0].Application_Status__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String fetchPreviousAppStatus(){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            List<Contact> con = [SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1];
            List<ApplicationForm__c> lApplication =[SELECT Id,Old_Status__c FROM ApplicationForm__c WHERE Id = :con[0].Application_Id__c LIMIT 1];
            return lApplication[0].Old_Status__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String fetchRejectionReason(){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            List<Contact> con = [SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1];
            List<ApplicationForm__c> lApplication =[SELECT Id,Old_Status__c,On_Hold_Candidate_Reason__c FROM ApplicationForm__c WHERE Id = :con[0].Application_Id__c LIMIT 1];
            return lApplication[0].On_Hold_Candidate_Reason__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String fetchOverallAppStatus(){
        try {
            Id ContactId = [SELECT ContactId FROM User where id =:UserInfo.getUserId() LIMIT 1]?.ContactId;
            List<Contact> con = [SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1];
            List<ApplicationForm__c> lApplication =[SELECT Id,Overall_Application_Status__c FROM ApplicationForm__c WHERE Id = :con[0].Application_Id__c LIMIT 1];
            return lApplication[0].Overall_Application_Status__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}