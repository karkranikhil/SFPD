public class ApplicationFormTriggerHandler {
    public static void ownerChange(List<ApplicationForm__c> lstNewApplicationForm, Map<Id,ApplicationForm__c> mOldApplication){
         for(ApplicationForm__c obj : lstNewApplicationForm){
            if(obj.OwnerId != null && obj.OwnerId != mOldApplication.get(obj.Id).OwnerId && string.valueOf(obj.OwnerId).startsWith('005') && obj.Application_Status__c.equals('Online Application')){
                obj.Application_Status__c ='Under Review';
                obj.No_activity_end_date__c  = System.today() +5; 
            }
             if(obj.Application_Status__c.equals('Under Review') && obj.Application_Status__c != mOldApplication.get(obj.Id).Application_Status__c){
                 obj.No_activity_end_date__c  = System.today() +5; 
             }
        }
    }
    public static void getRating(List<ApplicationForm__c> lstNewApplicationForm,Map<Id,ApplicationForm__c> mOldApplication){
        Map<Id,Integer> mapAppFamily = new Map<Id,Integer>();
        Integer rating = 0;
        /*if(mOldApplication.get()){

}*/
        for(Family_Member__c objFamily : [Select id,Application__c from Family_Member__c where Application__c in : mOldApplication.keySet() AND (NOT Name like '%a6z5%')]){
            mapAppFamily.put(objFamily.Application__c,1);
        }
        
        for(ApplicationForm__c obj : lstNewApplicationForm){
            obj.rating__c = 0;
            if(String.isNotBlank(obj.US_Veteran__c) &&  obj.US_Veteran__c.equals('Yes')){
                rating++;
            }
            if(obj.AI_ChineseCantonese__c  != null){
                rating++;
            }
            if(mapAppFamily.get(obj.Id) != null){
                rating++;
            }
            if(obj.AI_Tagalog_Philippines__c  != null){
                rating++;
            }
            if(String.isNotBlank(obj.EP_Is_Employee__c) &&  obj.EP_Is_Employee__c.equals('Yes')){
                rating++;
            }
            obj.rating__c =rating;
            
        }
        
    }
    
    public static void backGroundCheck(Map<Id,ApplicationForm__c> mNewApplicationForm,Map<Id,ApplicationForm__c> mOldApplicationForm){
        for(ApplicationForm__c app : mNewApplicationForm.values()){
            if(mNewApplicationForm.get(app.Id).Application_Status__c   =='Background' && mOldApplicationForm.get(app.Id).Application_Status__c   !='Background')
            {
                createBGVerifRecords(app.Id);
                createTaskRecords(app.Id,app.OwnerId,app.Contact__c);
            }
        }  
    }
    
    //Create 5 BackGround Records
    public static void createBGVerifRecords(Id applicationfromID){
        List<Background_Verification_Tasks__c> bgVer = new List<Background_Verification_Tasks__c>();
        
        Background_Verification_Tasks__c bg = new Background_Verification_Tasks__c();
        bg.Name='Upload required documents for Background Investigation';
        bg.Status__c='Pending';
        bg.Application__c=applicationfromID;
        bg.RecordTypeId = '0125f0000009uHmAAI'; //Upload Task
        bgVer.add(bg);
        
        Background_Verification_Tasks__c bg1 = new Background_Verification_Tasks__c();
        bg1.Name='Update Psychological Exam date';
        bg1.Status__c='Pending';
        bg1.Application__c=applicationfromID;
        bg1.RecordTypeId = '0125f0000009uHrAAI'; //Update Task
        bgVer.add(bg1);
        
        Background_Verification_Tasks__c bg2 = new Background_Verification_Tasks__c();
        bg2.Name='Update Polygraph Exam date';
        bg2.Status__c='Pending';
        bg2.Application__c=applicationfromID;
        bg2.RecordTypeId = '0125f0000009uHrAAI';//Update Task
        bgVer.add(bg2);
        
        Background_Verification_Tasks__c bg3 = new Background_Verification_Tasks__c();
        bg3.Name='Update test date for the use of controlled substances';
        bg3.Status__c='Pending';
        bg3.Application__c=applicationfromID;
        bg3.RecordTypeId = '0125f0000009uHrAAI';//Update Task
        bgVer.add(bg3);
        
        Background_Verification_Tasks__c bg4 = new Background_Verification_Tasks__c();
        bg4.Name='Update Medical Exam date';
        bg4.Status__c='Pending';
        bg4.Application__c=applicationfromID;
        bg4.RecordTypeId = '0125f0000009uHrAAI';//Update Task
        bgVer.add(bg4);
        
        Background_Verification_Tasks__c bg5 = new Background_Verification_Tasks__c();
        bg5.Name='Update Vision Test date';
        bg5.Status__c='Pending';
        bg5.Application__c=applicationfromID;
        bg5.RecordTypeId = '0125f0000009uHrAAI';//Update Task
        bgVer.add(bg5);
        
        Background_Verification_Tasks__c bg6 = new Background_Verification_Tasks__c();
        bg6.Name='Update Hearing Test date';
        bg6.Status__c='Pending';
        bg6.Application__c=applicationfromID;
        bg6.RecordTypeId = '0125f0000009uHrAAI';//Update Task
        bgVer.add(bg6);
        
        insert bgVer;
        
        //Insert 2 Document Records
        List<Background_Documents__c> lBackDoc = New List<Background_Documents__c>();
        
        Background_Documents__c  bdAuth1 = New Background_Documents__c ();
        bdAuth1.Name='Authorization of Release for Information';
        bdAuth1.Background_Verification_Tasks__c=bgVer[0].Id; //Upload Task Record
        bdAuth1.isRequired__c = true;
        lBackDoc.add(bdAuth1);
        
        Background_Documents__c  bdAuth2 = New Background_Documents__c ();
        bdAuth2.Name='Authorization of Release for Consumer Credit Report';
        bdAuth2.Background_Verification_Tasks__c=bgVer[0].Id; //Upload Task Record
        bdAuth2.isRequired__c = true;
        lBackDoc.add(bdAuth2);
        /*
        Background_Documents__c  bd0 = New Background_Documents__c ();
        bd0.Name='Consent Form (Notarized)';
        bd0.Background_Verification_Tasks__c=bgVer[0].Id; //Upload Task Record
        bd0.isRequired__c = true;
        lBackDoc.add(bd0);*/
        
        Background_Documents__c  bd = New Background_Documents__c ();
        bd.Name='Original Certified Birth Certificate/Certificate of Live Birth';
        bd.Background_Verification_Tasks__c=bgVer[0].Id; //Upload Task Record
        bd.isRequired__c = true;
        lBackDoc.add(bd);
        
        Background_Documents__c  bd1 = New Background_Documents__c ();
        bd1.Name='Original Social Security Card';
        bd1.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        bd.isRequired__c = true;
        lBackDoc.add(bd1);
        
        Background_Documents__c  bd2 = New Background_Documents__c ();
        bd2.Name='Driver License';
        bd2.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        bd.isRequired__c = true;
        lBackDoc.add(bd2);
        
        Background_Documents__c  bd3 = New Background_Documents__c ();
        bd3.Name='Proof of Citizenship (Original Naturalization Paper)';
        bd3.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd3);
        
        Background_Documents__c  bd4 = New Background_Documents__c ();
        bd4.Name='Original Certified Marriage Certificate';
        bd4.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd4);
        
        Background_Documents__c  bd5 = New Background_Documents__c ();
        bd5.Name='Original Certified Domestic Partnership License';
        bd5.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd5);
        
        Background_Documents__c  bd6 = New Background_Documents__c ();
        bd6.Name='Original Certified Divorce Decree/Dissolution of Domestic Partnership';
        bd6.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd6);
        
        Background_Documents__c  bd7 = New Background_Documents__c ();
        bd7.Name='Passport Type Photo';
        bd7.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd7);
        
        Background_Documents__c  bd8 = New Background_Documents__c ();
        bd8.Name='Passport';
        bd8.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd8);
        
        Background_Documents__c  bd9 = New Background_Documents__c ();
        bd9.Name='Official High School Transcript & Diploma & Address';
        bd9.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd9);
        
        Background_Documents__c  bd10 = New Background_Documents__c ();
        bd10.Name='Official College Transcript & Diploma (If Applicable) & Address';
        bd10.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd10);
        
        Background_Documents__c  bd11 = New Background_Documents__c ();
        bd11.Name='Divorce Documents (Final Divorce Decree)';
        bd11.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd11);
        
        Background_Documents__c  bd12 = New Background_Documents__c ();
        bd12.Name='DD-214 (Military Personnel)';
        bd12.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd12);
        
        Background_Documents__c  bd13 = New Background_Documents__c ();
        bd13.Name='Selective Service Documents (If Applicable)';
        bd13.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd13);
        
        Background_Documents__c  bd14 = New Background_Documents__c ();
        bd14.Name='Automobile Insurance Policy Declaration';
        bd14.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd14);
        
        Background_Documents__c  bd15 = New Background_Documents__c ();
        bd15.Name='Original Automobile Registration';
        bd15.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd15);
        
        Background_Documents__c  bd16 = New Background_Documents__c ();
        bd16.Name='All Civil Court Actions (Bankruptcies, Small Claims Court, Child Support, Etc.)';
        bd16.Background_Verification_Tasks__c=bgVer[0].Id;//Upload Task Record
        lBackDoc.add(bd16);
        
        insert lBackDoc;
        
    }
    
    public static void createTaskRecords(Id applicationfromID,Id ownerID,Id contactID){
        //Insert Task Records for recruiter
        List<Task> ltsk = new List<Task>();
        
        Task tsk = new Task();
        tsk.Subject = 'Upload Background Investigation results Status of the Test to be updated';
        tsk.Status = 'Open';
        tsk.Priority = 'Normal';
        tsk.WhatId  = applicationfromID;
        tsk.OwnerId = ownerID;
        tsk.WhoId  =contactID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk);
        
        
        Task tsk1 = new Task();
        tsk1.Subject = 'Upload Psychological Exam results Status of the Test to be updated';
        tsk1.Status = 'Open';
        tsk1.Priority = 'Normal';
        tsk1.WhatId  = applicationfromID;
        tsk1.OwnerId = ownerID;
        tsk1.WhoId  =contactID;
        tsk1.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk1);
        
        
        Task tsk2 = new Task();
        tsk2.Subject = 'Upload Polygraph Exam results Status of the Test to be updated';
        tsk2.Status = 'Open';
        tsk2.Priority = 'Normal';
        tsk2.WhatId  = applicationfromID;
        tsk2.OwnerId = ownerID;
        tsk2.WhoId  =contactID;
        tsk2.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk2);
        
        
        Task tsk3 = new Task();
        tsk3.Subject = 'Upload test results for the use of controlled substances Status of the Test to be updated';
        tsk3.Status = 'Open';
        tsk3.Priority = 'Normal';
        tsk3.WhatId  = applicationfromID;
        tsk3.OwnerId = ownerID;
        tsk3.WhoId  =contactID;
        tsk3.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk3);
        
        
        Task tsk4 = new Task();
        tsk4.Subject = 'Upload Medical Exam results Status of the Test to be updated';
        tsk4.Status = 'Open';
        tsk4.Priority = 'Normal';
        tsk4.WhatId = applicationfromID;
        tsk4.OwnerId = ownerID;
        tsk4.WhoId  =contactID;
        tsk4.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk4);
        
        Task tsk5 = new Task();
        tsk5.Subject = 'Update Vision Test date';
        tsk5.Status = 'Open';
        tsk5.Priority = 'Normal';
        tsk5.WhatId  = applicationfromID;
        tsk5.OwnerId = ownerID;
        tsk5.WhoId  =contactID;
        tsk5.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk5);
        
        
        Task tsk6 = new Task();
        tsk6.Subject = 'Update Hearing Test date';
        tsk6.Status = 'Open';
        tsk6.Priority = 'Normal';
        tsk6.WhatId  = applicationfromID;
        tsk6.OwnerId = ownerID;
        tsk6.WhoId =contactID;
        tsk6.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk6);
        
        insert ltsk;        
    }
    
    public static void overallAppStatusUpdate(Map<Id,ApplicationForm__c> mNewApplicationForm){
        for(ApplicationForm__c app : mNewApplicationForm.values()){
            if(mNewApplicationForm.get(app.Id).Application_Status__c == 'Pre-Qualification' || 
               mNewApplicationForm.get(app.Id).Application_Status__c == 'Online Application' ||
               mNewApplicationForm.get(app.Id).Application_Status__c == 'Qualifying Tests' ||
               mNewApplicationForm.get(app.Id).Application_Status__c == 'Background' ||
               mNewApplicationForm.get(app.Id).Application_Status__c == 'Under Review' ||
              mNewApplicationForm.get(app.Id).Application_Status__c == 'Eligibility List'){
                   mNewApplicationForm.get(app.Id).Overall_Application_Status__c = 'Active';
               }
            else if(mNewApplicationForm.get(app.Id).Application_Status__c == 'Disqualified-Closed'){
                mNewApplicationForm.get(app.Id).Overall_Application_Status__c = 'Closed'; 
            }
            else if(mNewApplicationForm.get(app.Id).Application_Status__c == 'Final Offer'){
                mNewApplicationForm.get(app.Id).Overall_Application_Status__c = 'Hired';  
            }
            else if(mNewApplicationForm.get(app.Id).Application_Status__c == 'On Hold'){
                mNewApplicationForm.get(app.Id).Overall_Application_Status__c = 'Hold';  
            }
            else{
                mNewApplicationForm.get(app.Id).Overall_Application_Status__c = 'In-Active';
            }
        }   
    }
    
    public static void onHoldStatusTransition(Map<Id,ApplicationForm__c> mNewApplicationForm,Map<Id,ApplicationForm__c> mOldApplicationForm){
        Set<Id> sQualifyingApp = new Set<Id>();
        Set<Id> sBackgroundApp = new Set<Id>();
        
        for(ApplicationForm__c app: mNewApplicationForm.values()){
            System.debug('OLD MAP '+mOldApplicationForm.get(app.Id).Application_Status__c);
            System.debug('NEW MAP '+mNewApplicationForm.get(app.Id).Application_Status__c);
            
            if(mOldApplicationForm.get(app.Id).Application_Status__c =='On Hold' && mNewApplicationForm.get(app.Id).Application_Status__c !='On Hold'){
                System.debug('NEW VS OLD '+mNewApplicationForm.get(app.Id).Application_Status__c == mOldApplicationForm.get(app.Id).Application_Status__c);
                if(mNewApplicationForm.get(app.Id).Application_Status__c =='Qualifying Tests')
                {
                    System.debug('APP ID'+app.Id);
                    sQualifyingApp.add(app.Id);    
                }
                if(mNewApplicationForm.get(app.Id).Application_Status__c =='Background'){
                    sBackgroundApp.add(app.Id);
                }
            }
        }
        
        if(!sQualifyingApp.isEmpty()){
            List<Registration__c> lRegUpdate = New List<Registration__c>();
            //If Pending Registration is Available Override Exam Due Date to Today()+14
            for(Registration__c reg : [SELECT Id,Status__c,Application__c,Registration_Date__c,Reporting_Time__c,Testing_Location__c
                                       FROM Registration__c
                                       WHERE Application__c IN :sQualifyingApp 
                                       AND (Status__c ='Pending' OR Status__c ='Registered')]){
                                           Registration__c rc = New Registration__c();
                                           rc.Id = reg.Id;
                                           rc.Registration_Date__c  =System.today();
                                           rc.Reporting_Time__c =null;
                                           rc.Testing_Location__c='';
                                           if(reg.Status__c =='Registered'){
                                               //Move Registered Registration to Pending and override Exam Due Date to Today()+14 reset all other fields
                                               rc.Status__c ='Pending';
                                           }
                                           lRegUpdate.add(reg);
                                       }
            if(lRegUpdate.size()>0){
                try{
                    update lRegUpdate;
                }catch(Exception e){
                    System.debug('##Exception '+e);
                }
            }
            
        }
        if(!sBackgroundApp.isEmpty()){
            List<Background_Verification_Tasks__c> lbgTaskUpdate = New List<Background_Verification_Tasks__c>(); 
            //If Pending BGV Update Task is available Override Exam Due Date to Today()+14
            for(Background_Verification_Tasks__c bg: [SELECT Id,Status__c,Preferred_Date__c,Application__c,RecordTypeId
                                                      FROM Background_Verification_Tasks__c
                                                      WHERE Application__c IN :sBackgroundApp
                                                      AND (Status__c ='Pending' OR Status__c ='Submitted')
                                                      AND RecordTypeId = '0125f0000009uHrAAI']){
                                                          Background_Verification_Tasks__c bgv = New Background_Verification_Tasks__c();
                                                          bgv.Id = bg.Id;
                                                          bgv.Preferred_Date__c = System.today();   
                                                          if(bg.Status__c =='Submitted'){
                                                              //Move Submitted BGV Update Task to Pending and override Exam Due Date to Today()+14 and reset all other fields
                                                              bgv.Status__c ='Pending';
                                                          }                                         
                                                          lbgTaskUpdate.add(bgv);    
                                                      }
            if(lbgTaskUpdate.size()>0){
                try{
                    update lbgTaskUpdate;
                }catch(Exception e){
                    System.debug('##Exception '+e);
                }
            }
        }
    }
    
    public static void cleanSampleRecord(Map<Id,ApplicationForm__c> mNewApplicationForm){
        
        List<Family_Member__c> lfMember = [SELECT Id from Family_Member__c WHERE Name LIKE 'a6z%' AND Application__c IN :mNewApplicationForm.keySet()];
        List<Education_Information__c> lEdInfo = [SELECT Id from Education_Information__c WHERE Name LIKE 'a74%' AND Application__c IN :mNewApplicationForm.keySet()];
        List<Employer__c> lempRec = [SELECT Id,Job_Title__c,
                                    Name_and_Title_of_supervisor__c,
                                    Nature_and_duties_of_your_position__c 
                                    FROM Employer__c 
                                    WHERE 
                                    Application__c IN :mNewApplicationForm.keySet()];
        try{
            delete lfMember;
        	delete lEdInfo;
            if(String.isBlank(lempRec[0].Job_Title__c)&&
                String.isBlank(lempRec[0].Name_and_Title_of_supervisor__c) &&
                String.isBlank(lempRec[0].Nature_and_duties_of_your_position__c)){
                 	delete lempRec;   
                }
        }
        catch(Exception e){
            System.debug('Exception '+e);
        }
    }
}