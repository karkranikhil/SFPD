import { LightningElement, wire, track } from 'lwc';
import bgpath from '@salesforce/resourceUrl/bgpathImg';
import bgAssignTskImg from '@salesforce/resourceUrl/psBGAssignTskImg';
import bgCheckOneTskImg from '@salesforce/resourceUrl/psBGCheckOneTskImg';
import checked from '@salesforce/resourceUrl/checked';
import unchecked from '@salesforce/resourceUrl/unchecked';
import { NavigationMixin } from "lightning/navigation";
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Contact.Name';
import DOCUPLOAD_FIELD from '@salesforce/schema/User.Contact.Document_Uploaded__c';
import fetchAllTasks from '@salesforce/apex/ContactDocController.fetchAllTasks';
import updateTask from '@salesforce/apex/ContactDocController.updateTask'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';


const Priority = ['Normal', 'Medium', 'High'];

export default class PsBgChkContainer extends NavigationMixin(LightningElement) {
    stagetitle = 'Stage Resources';
    faqtitle = 'Top FAQs'

    psPathImg = bgpath;
    psAssignBGTaskImg;
    checked = checked;
    unchecked = unchecked;


    @track name;
    docUploaded;
    currentPageReference = null;
    @track tasks = [];

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, DOCUPLOAD_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
        } else if (data) {
            this.name = data.fields.Contact.value.fields.Name.value;
            this.docUploaded = data.fields.Contact.value.fields.Document_Uploaded__c.value;
            this.psAssignBGTaskImg = this.docUploaded ? bgCheckOneTskImg : bgAssignTskImg
        }
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log(currentPageReference.state.applicationId)
            this.applicationId = currentPageReference.state.applicationId
        }
    }

    fetchTasks() {
        if (!this.applicationId) return;
        fetchAllTasks({ applicationId: this.applicationId })
            .then(result => {
                console.log(result)
                this.tasks = result.map((obj, index) => ({
                    ...obj,
                    Priority: Priority[obj.Name.length % 3],
                    Index: index + 1,
                    Checked: (obj.Status__c && (obj.Status__c == 'Pass' || obj.Status__c =='Verified')),
                    Submitted: obj.Status__c && obj.Status__c == 'Submitted',
                    ScheduleBtn : (obj.Status__c && obj.Status__c =='Pending'),
                    ReScheduleBtn :(obj.Status__c && obj.Status__c =='Fail'),
                    HasDate: obj.Name.toLowerCase().includes('date')
                }));
            })
            .catch(error => {
                console.log(error)
            })
    }


    connectedCallback() {
        this.fetchTasks();
    }
    selectHandler(event) {
        console.log('Div is clicked and item is' + event.currentTarget.dataset.item);//which element is being clicked
        var selectItem = event.currentTarget.dataset.item;
        let taskId = event.currentTarget.dataset.id;
        console.log('taskId :>> ', taskId);
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/s/calendar-page?item=' + selectItem + '&regId=' + taskId
            }
        }).then(generatedUrl => {
            window.open(generatedUrl, "_self");
        });
        // this.dispatchEvent(selectedEvent);
    }
    onClickHandler(event) {
        console.log(event.currentTarget.dataset.id);
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/s/document-upload?taskId=' + event.currentTarget.dataset.id + '&applicationId=' + this.applicationId
            }
        };
        this[NavigationMixin.Navigate](config);

    }

    handleConfirm(event) {
        let taskId = event.currentTarget.dataset.id;
        let taskDate = new Date(this.template.querySelector(`[data-id="${taskId}"]`).value);
        console.log(taskId, taskDate)
        updateTask({ taskId: taskId, taskDate: taskDate })
            .then(result => {
                console.log('HANDLE CONFIRM', result);
                this.fetchTasks();
            })
            .catch(error => {
                console.log(error)
                if (error.body && error.body.message) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    }));
                }
            })
    }

}