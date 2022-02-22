import { LightningElement,wire,track } from 'lwc';
import qImg from '@salesforce/resourceUrl/psQualify';
import checked from '@salesforce/resourceUrl/checked';
import unchecked from '@salesforce/resourceUrl/unchecked';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import fetchExams from '@salesforce/apex/ContactExamController.fetchExams';
import updateTask from '@salesforce/apex/ContactExamController.updateTask'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const Priority=['Normal','Medium','High'];
export default class PsQualifyingTestContainer extends NavigationMixin(LightningElement) {
    QualImg = qImg;
    checked = checked;
    unchecked = unchecked;

    @track name;
    @track tasks = [];

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
        } else if (data) {
            this.name = data.fields.Name.value;
        }
    }

    connectedCallback(){
        this.fetchTasks();
    }

    fetchTasks(){
        fetchExams()
        .then( result => {
            console.log(result)
            this.tasks = result.map((obj,index)=> ({ ...obj, 
                Priority: Priority[obj.Type__c.length%3], 
                Index: index+1, Checked: (obj.Status__c && obj.Status__c != 'Pending')
            }));
        })
        .catch( error => {
            console.log(error)
        })
    }

    handleConfirm(event){
        let taskId = event.currentTarget.dataset.id;
        let taskDate = new Date(this.template.querySelector(`[data-id="${taskId}"]`).value);
        console.log(taskId,taskDate)
        updateTask({taskId:taskId,taskDate:taskDate})
        .then( result => {
            console.log(result);
            this.fetchTasks();
        })
        .catch( error => {
            console.log(error)
            if (error.body && error.body.message){
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                }));
            }
        })
    }
    selectHandler(event){
        console.log('Div is cliecked and item is'+event.currentTarget.dataset.item);//which element is being clicked
        var  selectItem = event.currentTarget.dataset.item;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/s/calendar-page?item=' + selectItem
            }
        }).then(generatedUrl => {
            window.open(generatedUrl,"_self");
        });
        // this.dispatchEvent(selectedEvent);
    }
}