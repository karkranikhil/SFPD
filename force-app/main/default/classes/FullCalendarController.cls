/**
 * @name: FullCalendarController
 * @description: Controller class of fullCalendarJs lightning web component
 * @usage: it is used to fetch, create, delete events from lwc component.
 
 * @author: www.auraenabled.com
 */
public without sharing class FullCalendarController {
    /*private class MapOfUserColor{
        String UserName {get; set;}
        String Color {get; set;}
    }*/

    public class EventException extends Exception {}
    
     @AuraEnabled
    public static List<Event> fetchEvents(String itemName) {
        String subName = itemName;
        if (itemName == 'Written') {
            subName = 'Written Test';
        }
        else if (itemName == 'Physical') {
            subName = 'Physical Test';
        }
        else if(itemName == 'Interview') {
            subName = 'Oral Test';
        }
        else if(itemName == 'Update Psychological Exam date') {
            subName = 'Psychological Test';
        }
        else if(itemName == 'Update Polygraph Exam date') {
            subName = 'Polygraph Test';
        }
        else if(itemName == 'Update test date for the use of controlled substances') {
            subName = 'Controlled Substances Test';
        }
        else if(itemName == 'Update Medical Exam date') {
            subName = 'Medical Test';
        }
        else if(itemName == 'Update Vision Test date') {
            subName = 'Vision Test';
        }
        else if(itemName == 'Update Hearing Test date') {
            subName = 'Hearing Test';
        }
       /* return [SELECT Id,Who.Name,Subject,Format(StartDateTime),Location,IsAllDayEvent,Format(EndDateTime),WhoId,WhatId,Owner.Name 
                FROM Event Where Subject = :subName and CreatedDate>=LAST_N_MONTHS:3 ORDER BY CreatedDate DESC];
                
                
                String val = '2021-11-28T08:00:00.000Z'; 

                DateTime date1 = (DateTime)Json.deserialize('"'+val+'"', DateTime.class);

                System.debug(date1) ;

                String dateformat = 'yyyy-MM-dd HH:mm:ss:sssZ';
                String abc = date1.format(dateformat,''+userinfo.getTimeZone().toString());
                system.debug(abc);*/

       return [SELECT Id,Who.Name,Subject,Format(StartDateTime),Location,IsAllDayEvent,Format(EndDateTime),WhoId,WhatId,Owner.Name 
                FROM Event Where Subject = :subName and CreatedDate>=LAST_N_MONTHS:3 ORDER BY CreatedDate DESC];

    }

     
     @AuraEnabled
    public static Id fetchApplicationId(String taskId) {
        System.debug('Fetch Application');
        Id appId = null;
        //Registration Record
       if(taskId.startsWithIgnoreCase('a03')){
            System.debug('Fetch Application Registration');
           List<Registration__c> reg = [SELECT Id,Application__c FROM Registration__c WHERE Id = :taskId LIMIT 1 ];
            System.debug('Reg ID'+reg[0].Application__c);
           appId = reg[0].Application__c;
           return appId;
       }
       //BGV Task Record
       if(taskId.startsWithIgnoreCase('a71')){
            System.debug('Fetch Application BGV Task');
           List<Background_Verification_Tasks__c> bgTsk = [SELECT Id,Application__c FROM Background_Verification_Tasks__c WHERE Id = :taskId LIMIT 1];
            System.debug('Fetch Application BGV Task Id'+bgTsk[0].Application__c);
           appId = bgTsk[0].Application__c;
            return appId;
       }
       System.debug('NULL RETURN');
       return appId;
    }
    
}