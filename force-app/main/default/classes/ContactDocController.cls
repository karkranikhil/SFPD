public without sharing class ContactDocController {
    @AuraEnabled
    public static void saveAttachments(Id UserId,Id ConVerId,Id DocId){
      
        try {
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:ConVerId].ContentDocumentId;

            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = DocId; // Background Document Id
            cDe.ShareType = 'V';
            cDe.Visibility = 'AllUsers';
            insert cDe;

        } catch (Exception e) {
            System.debug('Exception'+e);
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
    public static string updateContactAndTask(Id taskId){
            Id ContactId = fetchContactId(UserInfo.getUserId());
            for(Background_Documents__c bgDoc: [SELECT Id,isRequired__c,(SELECT Id FROM AttachedContentDocuments) FROM Background_Documents__c WHERE 
            Background_Verification_Tasks__c = :taskId and isRequired__c = true]){
                if(bgDoc.AttachedContentDocuments.size()<1){
                    throw new AuraHandledException('Please upload required documents.');
                }
            }
            //update new Contact(Id = Contactid, Candidate_Stage__c = 'On Hold', Document_Uploaded__c = true);
            update new Contact(Id = Contactid, Document_Uploaded__c = true);
            List<Background_Verification_Tasks__c> tasks = new List<Background_Verification_Tasks__c>();
            for(Background_Verification_Tasks__c task:[SELECT Id, Status__c FROM Background_Verification_Tasks__c WHERE Id = :taskId AND (Name LIKE '%Background Investigation%' OR Name LIKE '%Authorization%')]){
                task.Status__c = 'Submitted';
                tasks.add(task);
            }
            update tasks;
            return 'Success';
    }

    @AuraEnabled
    public static Boolean applicationExists(){
        try {
            Id ContactId = fetchContactId(UserInfo.getUserId());
            List<ApplicationForm__c> apps = [Select id from ApplicationForm__c where Contact__c = :ContactId];
            if(apps.size()>0)
                return true;
            return false;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Background_Verification_Tasks__c> fetchAllTasks(Id applicationId){
        try {
            return [SELECT Id,Name,Status__c,Preferred_Date__c,Due_Date__c FROM Background_Verification_Tasks__c WHERE Application__c = :applicationId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Background_Documents__c> fetchAllBGDocs(Id taskId){
        try {
            return [SELECT Id,Name,isRequired__c,(SELECT Id,Title,ContentDocumentId FROM AttachedContentDocuments) FROM Background_Documents__c WHERE Background_Verification_Tasks__c = :taskId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateTask(Id taskId, Date taskDate){
        if(taskDate == null){
            throw new AuraHandledException('Please select a preferred date');
        }
        update new Background_Verification_Tasks__c(Id = taskId,Preferred_Date__c = taskDate, Status__c = 'Submitted');
        return 'Success';
    }


    @AuraEnabled
    public static string getSaveForLaterOmniscript(){
        Id ContactId = fetchContactId(UserInfo.getUserId());
        List<vlocity_ins__OmniScriptInstance__c> instanceList = [SELECT ID,vlocity_ins__RelativeResumeLink__c FROM vlocity_ins__OmniScriptInstance__c WHERE vlocity_ins__ObjectId__c = :ContactId];
        if(!instanceList.isEmpty()){
            return instanceList[0].vlocity_ins__RelativeResumeLink__c;
        }
        return ''; 
    }

     @AuraEnabled
    public static void removeAttachments(Id ConVerId){
        try {
           Database.delete(ConVerId);
        } catch (Exception e) {
            System.debug('Exception'+e);
        }
    }

    /*@AuraEnabled
    public static string fetchUserImage(){
        try {
            String userId = UserInfo.getUserId();
            String imageUrl = URL.getOrgDomainUrl().toExternalForm().replace('https://', '').split('\\.')[0];
            String versionId = '';
            string contentId = '';
            List<ContentDocument> photos = [
                SELECT Id, CreatedById, Title, LatestPublishedVersionId FROM ContentDocument WHERE Title =: 'Passport Photo' AND CreatedById =: userId ORDER BY CreatedDate DESC LIMIT 1
            ];
            versionId = photos[0].LatestPublishedVersionId;
            contentId = photos[0].Id;

            imageUrl = 'https://' + imageUrl.toLowerCase() + '--c.documentforce.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+versionId;
            return imageUrl;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}