public class ApplicationFlowHelper {
	public class FlowInputs {
        @InvocableVariable public String oldStatus;
    }
    
    public class FlowOutputs {
        @InvocableVariable public String label;
        @InvocableVariable public String value;
    }
    
    @InvocableMethod
    public static List<FlowOutputs> getPicklistValues(List<FlowInputs> input){
        String oldStatusValue = input[0].oldStatus;
        List<FlowOutputs> output = new List<FlowOutputs>();
        if(oldStatusValue == 'Background'){
            FlowOutputs out1 = new FlowOutputs();
            out1.label = 'test';
            out1.value = 'test';
            output.add(out1);
        }
        
        return output;
    }
}