trigger CalculateRating on Family_Member__c (After Insert) {/*
                                                             * Commented - Online. Application Form is failing because with the below reason - 
                                                             * CalculateRating: execution of AfterInsert caused by: System.JSONException:
                                                             *  Unable to serialize a map with a null key. Class.System.JSON.serialize: line 3, 
                                                             * column 1 Trigger.CalculateRating: line 11, column 1
                                                             * 
    Map<Id,Integer> mapAppRating= new Map<Id,Integer>();
    Map<Id,Integer> mapAppRating2= new Map<Id,Integer>();
    Set<Id> setId = new Set<Id>();
    Set<Id> setFamilyId = new Set<Id>();
    if(trigger.isAfter && trigger.isInsert){
        for(Family_Member__c obj : Trigger.new){
            mapAppRating.put(obj.Application__c,0);
            setFamilyId.add(obj.id);
        }
        system.debug('========= mapAppRating '+JSON.serialize(mapAppRating));
        List<Family_Member__c> lstFamity = [Select Application__c,Application__r.rating__c from Family_Member__c where Application__c in: mapAppRating.keySet()
                                          ];
        mapAppRating.clear();
        for(Family_Member__c obj : lstFamity){
            if(setFamilyId.contains(obj.Id)){
                mapAppRating2.put(obj.Application__c,Integer.valueOf(obj.Application__r.rating__c));
            }else {
                mapAppRating.put(obj.Application__c,0);
            }
            
        }
        system.debug('========= mapAppRating 2 '+JSON.serialize(mapAppRating));
        for(Family_Member__c obj : Trigger.new){
            if(mapAppRating.get(obj.Application__c) ==null ){
                //obj.rating__c = obj.rating__c+1;
                setId.add(obj.Application__c);
            }
        }
        system.debug('========= mapAppRating 2 '+JSON.serialize(mapAppRating));
        system.debug('========= setId  '+setId);
        List<ApplicationForm__c> lstApp = new List<ApplicationForm__c>();
        for(Id iterateIds : setId){
            ApplicationForm__c objApp = new ApplicationForm__c(id=iterateIds,rating__c=mapAppRating2.get(iterateIds)+1);
            lstApp.add(objApp);
            system.debug('========= lstApp  '+lstApp);
        }
        if(!lstApp.isEmpty()){
            update lstApp;
            system.debug('========= lstApp  '+lstApp);
        }
    }*/
    
}