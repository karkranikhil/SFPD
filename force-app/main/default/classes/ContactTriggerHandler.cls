public class ContactTriggerHandler {
    public static void backGroundCheck(Map<Id,Contact> mNewContact,Map<Id,Contact> mOldContact){
        for(Contact c : mNewContact.values()){
            if(mNewContact.get(c.Id).Candidate_Stage__c =='Background' && mOldContact.get(c.Id).Candidate_Stage__c !='Background')
            {
                createBGRecords(c.Id);
                createTaskRecords(c.Id,c.OwnerId);
            }
        }  
    }
    
    //Create 5 BackGround Records
    public static void createBGRecords(Id contactID){
        List<Background_Verification_Tasks__c> bgVer = new List<Background_Verification_Tasks__c>();
        Background_Verification_Tasks__c bg = new Background_Verification_Tasks__c();
        bg.Name='Upload required documents for Background Investigation';
        bg.Status__c='Pending';
        bg.Contact__c=contactID;
        bgVer.add(bg);
        
        Background_Verification_Tasks__c bg1 = new Background_Verification_Tasks__c();
        bg1.Name='Update Psychological Exam date';
        bg1.Status__c='Pending';
        bg1.Contact__c=contactID;
        bgVer.add(bg1);
        
 		Background_Verification_Tasks__c bg2 = new Background_Verification_Tasks__c();
        bg2.Name='Update Polygraph Exam date';
        bg2.Status__c='Pending';
        bg2.Contact__c=contactID;
        bgVer.add(bg2);
       
        Background_Verification_Tasks__c bg3 = new Background_Verification_Tasks__c();
        bg3.Name='Update test date for the use of controlled substances';
        bg3.Status__c='Pending';
        bg3.Contact__c=contactID;
        bgVer.add(bg3);
        
        Background_Verification_Tasks__c bg4 = new Background_Verification_Tasks__c();
        bg4.Name='Update Medical Exam date';
        bg4.Status__c='Pending';
        bg4.Contact__c=contactID;
        bgVer.add(bg4);
        
        Background_Verification_Tasks__c bg5 = new Background_Verification_Tasks__c();
        bg5.Name='Update Vision Test date';
        bg5.Status__c='Pending';
        bg5.Contact__c=contactID;
        //bgVer.add(bg5);
        
        Background_Verification_Tasks__c bg6 = new Background_Verification_Tasks__c();
        bg6.Name='Update Hearing Test date';
        bg6.Status__c='Pending';
        bg6.Contact__c=contactID;
       // bgVer.add(bg6);

        insert bgVer;
        
        //Insert 2 Document Records
        List<Background_Documents__c> lBackDoc = New List<Background_Documents__c>();

        Background_Documents__c  bd = New Background_Documents__c ();
        bd.Name='Original Certified Birth Certificate/Certificate of Live Birth';
        bd.Contact__c=contactID;
        lBackDoc.add(bd);
        
        Background_Documents__c  bd1 = New Background_Documents__c ();
        bd1.Name='Original Social Security Card';
        bd1.Contact__c=contactID;
        lBackDoc.add(bd1);
        
        insert lBackDoc;
        
    }
    
    public static void createTaskRecords(Id contactID,Id ownerID){
        //Insert Task Records for recruiter
        List<Task> ltsk = new List<Task>();
        
        Task tsk = new Task();
        tsk.Subject = 'Upload Background Investigation results Status of the Test to be updated';
        tsk.Status = 'Open';
        tsk.Priority = 'Normal';
        tsk.WhoId = contactID;
        tsk.OwnerId = ownerID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk);
        
         
        Task tsk1 = new Task();
        tsk1.Subject = 'Upload Psychological Exam results Status of the Test to be updated';
        tsk1.Status = 'Open';
        tsk1.Priority = 'Normal';
        tsk1.WhoId = contactID;
        tsk1.OwnerId = ownerID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk1);
        
         
        Task tsk2 = new Task();
        tsk2.Subject = 'Upload Polygraph Exam results Status of the Test to be updated';
        tsk2.Status = 'Open';
        tsk2.Priority = 'Normal';
        tsk2.WhoId = contactID;
        tsk2.OwnerId = ownerID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk2);
        
         
        Task tsk3 = new Task();
        tsk3.Subject = 'Upload test results for the use of controlled substances Status of the Test to be updated';
        tsk3.Status = 'Open';
        tsk3.Priority = 'Normal';
        tsk3.WhoId = contactID;
        tsk3.OwnerId = ownerID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk3);
        
         
        Task tsk4 = new Task();
        tsk4.Subject = 'Upload Medical Exam results Status of the Test to be updated';
        tsk4.Status = 'Open';
        tsk4.Priority = 'Normal';
        tsk4.WhoId = contactID;
        tsk4.OwnerId = ownerID;
        tsk.ActivityDate = Date.today().addDays(14);
        ltsk.add(tsk4);
        
        insert ltsk;
        
    }
}