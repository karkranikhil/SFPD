@JsonAccess(serializable='always')
global without sharing class PdNewUser implements vlocity_ins.VlocityOpenInterface2 {
    global Object invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Map<String,Object> inputOS = (Map<String,Object>)input.get('Interest_Form');
        Map<String,Object> inputSQ = (Map<String,Object>)input.get('Supplemental_Questionnaire');
        Savepoint sp = null;
        Boolean isQualified = false;
        System.debug('INTO::'+inputSQ);
        try {
            sp = Database.setSavepoint();
            String fname = inputOS.containsKey('First_name_value') ? (String)inputOS.get('First_name_value'):'';
            String lname = (String)inputOS.get('Last_name_value');
            //Date birthDate = inputOS.containsKey('dob_value') ? Date.valueOf((String)inputOS.get('dob_value')):null;
            String email = (String)inputOS.get('Email_ID_value');
            String phone = (String)inputOS.get('Phone_number_value');
            String applyingFor = (String)inputOS.get('Applying_for_value');
            
            
            String US_Citizen_value = inputSQ.containsKey('US_Citizen_value') ? (String)inputSQ.get('US_Citizen_value'):'';
            String age_value = inputSQ.containsKey('age_value') ? (String)inputSQ.get('age_value'):'';
            String driving_licence_value = inputSQ.containsKey('driving_licence_value') ? (String)inputSQ.get('driving_licence_value'):'';
            String Us_high_school_value = inputSQ.containsKey('Us_high_school_value') ? (String)inputSQ.get('Us_high_school_value'):'';
            String domestic_violence_value = inputSQ.containsKey('domestic_violence_value') ? (String)inputSQ.get('domestic_violence_value'):'';
            String convicted_value = inputSQ.containsKey('convicted_value') ? (String)inputSQ.get('convicted_value'):'';
            String felon_crime_value = inputSQ.containsKey('felon_crime_value') ? (String)inputSQ.get('felon_crime_value'):'';
            String restricted_value = inputSQ.containsKey('restricted_value') ? (String)inputSQ.get('restricted_value'):'';
            String sfpd_background_value = inputSQ.containsKey('sfpd_background_value') ? (String)inputSQ.get('sfpd_background_value'):'';
            String Permanent_value = inputSQ.containsKey('Permanent_value') ? (String)inputSQ.get('Permanent_value'):'';
            String Naturalized_value = inputSQ.containsKey('Naturalized_value') ? (String)inputSQ.get('Naturalized_value'):'';
            
            // create new contact
            if( age_value == 'Yes' && driving_licence_value == 'Yes' && Us_high_school_value == 'Yes' && domestic_violence_value == 'No' && convicted_value == 'No' && felon_crime_value == 'No' && restricted_value == 'No' && sfpd_background_value == 'No'){
               isQualified = true; 
            }
            List<Contact> contactList = [SELECT ID FROM Contact WHERE Email = :email AND FirstName = :fname];
            Account accObj;
            Contact contObj;
            Boolean createUser = false;
            if(!contactList.isEmpty()){
                List<User> userList = [SELECT ID FROM User WHERE ContactId = :contactList[0].Id];
                contObj = contactList[0];
                if(userList.isEmpty() && isQualified){
                    createUser = true;
                }
            } else {
                accObj = new Account(Name=lname,OwnerId='0055f000004RWXCAA4',RecordTypeId='0125f0000009ZY9AAM');//,OwnerId =Label.SelRegOwnerId
                INSERT accObj;
                contObj = new Contact(FirstName=fname,LastName=lname,RecordTypeId='0125f0000009ZYYAA2',Email=email,AccountId=accObj.Id, Candidate_Stage__c ='Pre-qualification',
                    Applying_For__c=applyingFor,Phone=phone);
                
                if( isQualified){
                    contObj.Candidate_Stage__c ='Online Application';
                    createUser = true;
                }
                INSERT contObj;
                
                System.debug('CONTACT::'+contObj);
                System.debug('ACCOUNT::'+accObj);
                
            }
            
            /*Account accObj = new Account(Name=lname,OwnerId='0055f000004RWXCAA4',RecordTypeId='0125f0000009ZY9AAM');//,OwnerId =Label.SelRegOwnerId
            INSERT accObj;
            Contact contObj = new Contact(FirstName=fname,LastName=lname,RecordTypeId='0125f0000009ZYYAA2',Email=email,AccountId=accObj.Id, Candidate_Stage__c ='Pre-qualification',
                Applying_For__c=applyingFor,Phone=phone);
            
            if( age_value == 'Yes' && driving_licence_value == 'Yes' && Us_high_school_value == 'Yes' && domestic_violence_value == 'No' && convicted_value == 'No' && felon_crime_value == 'No' && restricted_value == 'No' && sfpd_background_value == 'No'){
                contObj.Candidate_Stage__c ='Online Application';
            }
            INSERT contObj;
            
            System.debug('CONTACT::'+contObj);
            System.debug('ACCOUNT::'+accObj);*/
            
            if(createUser){
                Profile prof = [select id,userType from Profile where name='PS Portal' limit 1];
                String alias = (fname != null ? fname.substring(0,1).toUpperCase() :'') + 
                    (lname.length() > 6 ? lname.substring(0,6) : lname);
                String nickname = ((fname != null && fname.length() > 0) ? fname.substring(0,1) : '' ) + lname.substring(0,1);
                nickname        = nickname + String.valueOf(Crypto.getRandomInteger()).substring(1,7);
                //cond to check if ans is yes then create new user
                if( US_Citizen_value == 'Yes' && age_value == 'Yes' && driving_licence_value == 'Yes' && Us_high_school_value == 'Yes' && domestic_violence_value == 'No' && convicted_value == 'No' && felon_crime_value == 'No' && restricted_value == 'No' && sfpd_background_value == 'No'){
                    System.debug('USER::'+inputSQ);
                    User userObj = new User(
                        Username   = email+'.mtxri',
                        Email      = email,
                        FirstName  = fname,
                        LastName   = lname,
                        ProfileId = prof.id,
                        contactId = contObj.Id,
                        emailEncodingKey  = 'UTF-8',
                        languageLocaleKey ='en_US',
                        localesIdKey = 'en_CA',
                        alias = alias,
                        CommunityNickname= nickname,
                        TimeZoneSidKey = 'GMT'
                    );
                    String networkId = Network.getNetworkId();
                    /**If using site to host the community the user should not hit s1 after logging in from mobile. */
                    if(networkId != null && siteAsContainerEnabled(networkId)) userObj.put('UserPreferencesHideS1BrowserUI',true);
                    INSERT userObj;
                }
            }
            
            ApplicationForm__c newApplication = new ApplicationForm__c();
            newApplication.Contact__c = contObj.Id;
            newApplication.Application_Status__c = isQualified ? 'Online Application' : 'Pre-Qualification';
            newApplication.Applying_For__c = applyingFor;
            newApplication.Pre_qualification_Outcome__c = isQualified ? 'Qualified' : 'Disqualified';
            //question resposes
            newApplication.IsUSCitizen__c = US_Citizen_value;
            newApplication.Is_20_years_of_age__c = age_value;
            newApplication.Has_Driver_License__c = driving_licence_value;
            newApplication.Has_U_S_High_School_Diploma__c = Us_high_school_value;
            newApplication.Is_convicted_to_Domestic__c = domestic_violence_value;
            newApplication.Is_misdemeanor__c = convicted_value;
            newApplication.Is_felony__c = felon_crime_value;
            newApplication.Restricted_from_SF_employment__c = restricted_value;
            newApplication.Disqualified_within_the_last_two_years__c = sfpd_background_value;
            newApplication.Is_Naturalized_Citizen__c = Naturalized_value;
            newApplication.Is_Permanent_Resident__c = Permanent_value;
            insert newApplication;
        } catch(Exception exp) {
            Database.rollback(sp);
            return exp.getMessage(); 
        }
        return null;
    }
     @TestVisible
     private static boolean siteAsContainerEnabled(Id networkId) {
         Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
         return authConfig.isCommunityUsingSiteAsContainer();
     }
}