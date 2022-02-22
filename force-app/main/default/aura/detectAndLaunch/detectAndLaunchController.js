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
            
        }
    },
    
    recordUpdated: function(component, event, helper) {
        console.log('entering recordUpdate');
        var eventParams = event.getParams();
        console.log(JSON.stringify(eventParams.changedFields));

        if(eventParams.changeType === "CHANGED" && ('Application_Status__c' in eventParams.changedFields) ) {
            var newStatus = eventParams.changedFields.Application_Status__c.value;
        	var oldStatus = eventParams.changedFields.Application_Status__c.oldValue;
            component.set("v.oldStatusValue",oldStatus);
            component.set("v.newStatusValue",newStatus);
            if(newStatus == 'Disqualified-Closed' && oldStatus != 'Disqualified-Closed'){
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
    }


    

            
})