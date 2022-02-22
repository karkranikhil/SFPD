({
    submitDetails: function (component, event, helper) {
        var action = component.get("c.disqualifyMail");
        var reason = component.get("v.reason");
        var recordId = component.get("v.recordId");
        // var otherField = component.get("v.otherField");
        var primaryReason = component.get("v.primaryReason");

        if (primaryReason === 'Other') {
            primaryReason = reason;
        }
        else {
            // console.log('primaryReason :>> ', primaryReason);
            // var selectedTemplateId =  "2F00X5f000000E73A";
            // if(selectedTemplateId!= undefined && selectedTemplateId!="" && selectedTemplateId!="undefined")
            // {
            //     helper.getEmailBody(component, event, helper);  
            // }
            // else
            // {
            //     var inputCmp = component.find("templateId");
            //     inputCmp.setCustomValidity("Please select a value");
            //     inputCmp.reportValidity();     
            // }
        }
        console.log('ID :>> ', recordId);
        action.setParams({ message: primaryReason, recordId: recordId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('response.getRe :>> ', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    doinit: function (component, event, helper) {
        var pickvar = component.get("c.getPickListValuesIntoList");
        pickvar.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var list = response.getReturnValue();
                console.log('List :>> ', list);
                component.set("v.picvalue", list);
            }
            else if (state === 'ERROR') {
                alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(pickvar);
    },
    handleChange: function (component, event, helper) {
        var primaryReason = component.get("v.primaryReason");
        // console.log('otherField :>> ' + otherField);
        if (primaryReason === 'Other') {
            component.set('v.otherField', true);
            var otherField = component.get("v.otherField");
            console.log('otherField :>> ' + otherField);
        }
        else {
            component.set('v.otherField', false);
            var otherField = component.get("v.otherField");
            console.log('otherField :>> ' + otherField);
        }
    }
})