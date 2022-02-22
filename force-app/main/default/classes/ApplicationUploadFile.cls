global class ApplicationUploadFile implements vlocity_ins.VlocityOpenInterface{
    public Boolean invokeMethod(String methodName, Map < String, Object >
		input, Map < String, Object > outMap, Map < String, Object > options) {
            if (methodName.equals('resume')) {
                system.debug('Input'+input);
                system.debug('Output'+ outMap);
                system.debug('Options'+ options);
                resume(input);
        	}
            if (methodName.equals('driverLicence')){
                driverLicence(input);
            }
            if (methodName.equals('Passport')){
                Passport(input);
            }
            if (methodName.equals('PassportTypePhoto')){
                PassportTypePhoto(input);
            }
            if (methodName.equals('HighSchoolDiploma')){
                HighSchoolDiploma(input);
            }
            if (methodName.equals('CollegeDiploma')){
                CollegeDiploma(input);
            }
            if (methodName.equals('legibleCopy')){
                legibleCopy(input);
            }
            if (methodName.equals('copyAward')){
                copyAward(input);
            }
        return true;
    }
    public static void resume(Map <String, Object> inputMap){
        system.debug('Resume called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('resumeUpload');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Resume'));
        }
        update cv;
    }
    public static void driverLicence(Map <String, Object> inputMap){
        system.debug('driverLicence called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('diverLicense');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Driver License'));
        }
        update cv;
    }
    public static void Passport(Map <String, Object> inputMap){
        system.debug('Passport called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('Passport');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Passport'));
        }
        update cv;
    }
    public static void PassportTypePhoto(Map <String, Object> inputMap){
        system.debug('PassportTypePhoto called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('passportPhoto');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Passport Photo'));
        }
        update cv;
    }
    public static void HighSchoolDiploma(Map <String, Object> inputMap){
        system.debug('HighSchoolDiploma called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('officialHighSchool');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'High School Diploma'));
        }
        update cv;
    }
    public static void CollegeDiploma(Map <String, Object> inputMap){
        system.debug('CollegeDiploma called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('officialCollege');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'College Diploma'));
        }
        update cv;
    }
    //new add fun
    public static void legibleCopy(Map <String, Object> inputMap){
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('File1');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Legible copy of DD214'));
        }
        try {
            update cv;
        } catch (Exception e) {
            system.debug('Exception>>>>'+e);
        }
    }
    public static void copyAward(Map <String, Object> inputMap){
        system.debug('copyAward called');
        String ip = JSON.serialize(inputMap);
        Map<String,List<Map<String, String>>> temp2 = (Map<String, List<Map<String, String>>>) JSON.deserialize(ip, Map<String, List<Map<String, String>>>.class);
        system.debug('Temp2>>>>'+temp2);
        List<Map<String, String>> temp = temp2.get('File2');
        system.debug('temp>>>'+temp);
        List<ContentVersion> cv = new List<ContentVersion>();
        for(Map<String, String> t: temp){
            cv.add(new ContentVersion(Id = t.get('vId'), Title = 'Copy of the award letter'));
        }
        try {
            update cv;
            } catch (Exception e) {
                system.debug('Exception>>>>'+e);
            }
    }
}