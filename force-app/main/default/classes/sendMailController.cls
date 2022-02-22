public without sharing class sendMailController {
//     @AuraEnabled
//    public static String disqualifyMail(String message,String recordId){
//         List<Contact> contactList = new List<Contact>();
//         contactList = [SELECT Id,Email 
//                             FROM Contact 
//                             WHERE Id = :recordId];
//         String email = contactList[0].Email;

//         Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();  
//         String[] sendingTo = new String[]{email};
//         semail.setToAddresses(sendingTo);
//         semail.setSubject('Disqualify ');
//         semail.setPlainTextBody('Reason For Disqualification - ' + message);
//         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
//         return 'send';
//     }
    @AuraEnabled
   public static String disqualifyMail(String message,String recordId){
        List<ApplicationForm__c> appList = new List<ApplicationForm__c>();
        appList = [SELECT Id,Contact__r.Email 
                            FROM ApplicationForm__c
                            WHERE Id = :recordId];
        String email = appList[0].Contact__r.Email;
        String Name = UserInfo.getName();//Returns the context user's full name.
        String mailBody = 'Unfortunately, you have not met the minimum Pre-Qualification criteria for the position of ""APPLY FOR SELECTION"" (Auto populated from ""Apply for"" question).'+'/n'+'Thank you for your interest in becoming a Police Officer with the MTX Police Department. After a review of your Pre-Qualification submission, you currently do not meet minimum qualifications. We are unfortunately unable to process your application request at this time for the reason(s) outlined below:'+ '/n'+'Are you at least 20 years of age?'+'/n'+'The following field on the message should be dynamically populated'+'/n'+'Once you have been able to address these items, please revisit our site and apply again if you believe if you received this message in error, please contact our recruitment office at 123-123-1234'+'/n'+'Based on your Pre-Qualification response(s), We would encourage you to consider the below listed employment opportunities within the MTX Police Department. To learn more about and apply for these opportunities, Click on the links below:';
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();  
        String[] sendingTo = new String[]{email};
        semail.setToAddresses(sendingTo);
        semail.setSubject('Disqualify by '+ Name);
        semail.setPlainTextBody('Reason For Disqualification - ' + message + '/n' + mailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        return 'send';
    }
    @AuraEnabled      
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = ApplicationForm__c.Disqualify_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
}