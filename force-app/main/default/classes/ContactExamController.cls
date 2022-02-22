public without sharing class ContactExamController {

    @AuraEnabled
    public static List<Registration__c> fetchExams(){
        try {
            Id ContactId = fetchContactId(UserInfo.getUserId());
            List<Contact> con = [
                SELECT Id, Application_Id__c, Application_Status__c from Contact WHERE Id =: ContactId LIMIT 1
                ];
            //List<ApplicationForm__c> applications = [SELECT Id,Contact__c FROM ApplicationForm__c WHERE Contact__c = :ContactId];
            //Set<Id> appIds = (new Map<Id,ApplicationForm__c>(applications)).keySet();
            Set<Id> appIds = new Set<Id>();
            appIds.add(con[0].Application_Id__c);
            List<Registration__c> exams = [SELECT Id,Type__c,Status__c,Registration_Date__c,Test_Schedule_Date__c,Test_Date__c,isDisabled__c,Testing_Location__c,Test_Time__c,Reporting_Time__c FROM Registration__c WHERE Application__c IN :appIds ORDER BY Sequence__c];
            return exams;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String fetchContactId(Id UserId){
        try {
             //Fetch the Contact Id from User Id and then find the Background Doucment Id to attach the file
             List<User> usr = [SELECT ContactId FROM User where id =:UserId LIMIT 1];
             if(usr.size()>0){
                return usr[0].ContactId;   
             }
             return null;       
        } catch (Exception e) {
            System.debug('Exception'+e);
            return null;
        }
    }

    @AuraEnabled
    public static string updateTask(Id taskId, Date taskDate,String testTime,Id eventId){
        if(taskDate == null){
            throw new AuraHandledException('Please select a preferred date');
        }

        Date todaysDate = System.today();
        List<Event> lEvent = [SELECT Id,StartDateTime FROM Event Where Id = :eventId LIMIT 1];

        /*
        String[] strTimeSplit = testTime.split(':');
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),00,000);   
        Time reportingTime = Time.newInstance( Integer.valueOf(strTimeSplit[0]) ,Integer.valueOf(strTimeSplit[1]) - 30 ,00 ,000); 


        //Fetch the Event Details 
        List<Event> lEvent = [SELECT Id,StartDateTime FROM Event Where Id = :eventId LIMIT 1];

        /*Get current date time in GMT format
        String val = '2021-11-24T11:00:00.000+0000'; 

        DateTime dt = (DateTime)Json.deserialize('"'+val+'"', DateTime.class);

        Convert StartDateTime into GMT.
        String dtGMT = lEvent[0].StartDateTime.format('yyyy-MM-dd HH:mm:ss', 'GMT');
        
        return Datetime.now().format('hh:mm:ss a');

        Get Time*/

        System.debug('Date Time from Event '+lEvent[0].StartDateTime);

        System.debug('Time from Event '+lEvent[0].StartDateTime.time());



        update new Registration__c(Id = taskId,Registration_Date__c = todaysDate, Status__c = 'Registered', Testing_Location__c = 'San Francisco',Test_Time__c = lEvent[0].StartDateTime.time(),
        Reporting_Time__c = lEvent[0].StartDateTime.time().addMinutes(-30),Test_Schedule_Date__c=taskDate);
        Registration__c reg = [SELECT ID,Application__c,Application__r.Contact__c,Application__r.Contact__r.Email,Type__c,Application__r.OwnerId FROM Registration__c WHERE Id = :taskId];
        User u = [SELECT ID,Email FROM User Where ContactId = :reg.Application__r.Contact__c];
        Task newTask = new Task();
        newTask.WhoId = reg.Application__r.Contact__c;
        newTask.WhatId = reg.Application__c;
        //newTask.Email = reg.Application__r.Contact__r.Email;
        newTask.Status = 'Not Started';
        newTask.Priority = 'Normal';
        newTask.Subject = 'Complete the ' + reg.Type__c  +' Test' ;
        //newTask.OwnerId = u.Id; 
        newTask.ActivityDate = Date.Today().addDays(14);
        insert newTask;

        Task newTask1 = new Task();
        newTask1.OwnerId = reg.Application__r.OwnerId;
        newTask1.WhatId = reg.Application__c;
        newTask1.Status = 'Not Started';
        //newTask1.Email = u.Email;
        newTask1.Priority = 'Normal';
        newTask1.Subject = 'Update the ' + reg.Type__c  +' Test Results' ;
        //newTask1.OwnerId = u.Id; 
        newTask1.ActivityDate = Date.Today().addDays(14);
        insert newTask1;

        return 'Success';
    }
    @AuraEnabled
    public static string updateRegister(Date testDate){
        try {
            String str;
            Date today = date.today();
            Registration__c app = new Registration__c();
            app.Registration_Date__c = today;
            app.Registration_Date__c = testDate;
            app.Status__c = 'Registered';
            // app.Completed_Steps__c = '1';
            insert app;

            str = app.Id;
            return str;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}