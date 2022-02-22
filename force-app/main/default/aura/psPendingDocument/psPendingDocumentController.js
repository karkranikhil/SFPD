({
    
    openModal : function(component, event, helper) {
        component.set('v.openModal',true);
    },
    
    closeModal : function(component, event, helper) {
        component.set('v.openModal',false);
    },
    
    
    
    flowStatusChange : function( component, event, helper ) {
        if ( event.getParam( "status" ).indexOf( "FINISHED" ) !== -1 ) {
            component.set( "v.openModal", false );
             //Added to refresh record details after modal close
             $A.get('e.force:refreshView').fire();
            
        }
    },
    
    recordUpdated: function(component, event, helper) {
        console.log('entering recordUpdate');
        var eventParams = event.getParams();
        console.log(JSON.stringify(eventParams.changedFields));
        
        if(eventParams.changeType === "CHANGED" && ('Status__c' in eventParams.changedFields) ) {
            var newStatus = eventParams.changedFields.Status__c.value;
            var oldStatus = eventParams.changedFields.Status__c.oldValue;
            component.set("v.oldStatusValue",oldStatus);
            component.set("v.newStatusValue",newStatus);
            if(newStatus == 'Pending' && oldStatus != 'Pending'){
                component.set("v.targetFlowName", component.get("v.editFlowName"));
                helper.processChangeEvent(component, eventParams);
            }
            if(newStatus == 'On Hold' && oldStatus != 'On Hold'){
                component.set("v.targetFlowName", component.get("v.editFlowName"));
                helper.processChangeEvent(component, eventParams);
            }
            
        }   
        else if(eventParams.changeType === "ERROR") {
            console.log(eventParams);
            console.log('Update event received Error: ' + component.get("v.error"));
        }
    },
    closeModel : function(component, event, helper){
        component.set( "v.openModal", false );
        //Added to refresh record details after modal close
         $A.get('e.force:refreshView').fire();
    }
    
    
    
    
    
})