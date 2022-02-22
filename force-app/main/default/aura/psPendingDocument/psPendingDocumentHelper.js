({
    processChangeEvent : function(component, eventParams) {
        console.log('entering processChangeEvent');
        if(eventParams.changeType === "CHANGED") {
            console.log ('changeType is: ' + eventParams.changeType);
            if(component.get("v.launchMode") == 'Modal') {
                component.set('v.openModal',true);

                //Set input variable
                var inputVariable = [
                    {
                        name : "recordId",
                        type : "String",
                        value: component.get("v.recordId")
                    }
                ];

                var flow = component.find("flow");
                flow.startFlow(component.get("v.targetFlowName"), inputVariable); //added input variable

            } 
            
        
            

        } 
    }

    
})