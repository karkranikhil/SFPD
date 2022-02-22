import { LightningElement, track } from 'lwc';
import fetchCurrentApplication from '@salesforce/apex/ContactDashboardController.fetchCurrentApplication';
import fetchPreviousAppStatus from '@salesforce/apex/ContactDashboardController.fetchPreviousAppStatus';
import fetchRejectionReason from '@salesforce/apex/ContactDashboardController.fetchRejectionReason';
import fetchExams from '@salesforce/apex/ContactExamController.fetchExams';
import updateTask from '@salesforce/apex/ContactExamController.updateTask';
import checked from '@salesforce/resourceUrl/checked';
import unchecked from '@salesforce/resourceUrl/unchecked';
import facebookicon from '@salesforce/resourceUrl/facebookicon';
import twittericon from '@salesforce/resourceUrl/twittericon1';
import emailicon from '@salesforce/resourceUrl/emailicon';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const Priority = ['Normal', 'Medium', 'High'];

export default class PsHomeVariation extends NavigationMixin(LightningElement) {
    @track currentAppStatus = ''; 
    @track stageNo = '';
    @track previousStage ='';
    @track tasks = [];
    @track showSpinner = false;
    @track showApply = false;
    @track  testTime;
    @track  regTime;
    @track showApply = false;
    onHoldReason = '' ;
    checked = checked;
    unchecked = unchecked;
    facebookicon = facebookicon;
    twittericon = twittericon;
    emailicon = emailicon;
    stagetitle = 'Stage Resources';
    faqtitle = 'Top FAQs'
    @track notQualified;

    connectedCallback() {
        this.showSpinner = true;
        fetchCurrentApplication()
            .then(result => {
                console.log('fetchCurrentApplication Result: ', result);
                this.currentAppStatus = result;
                //this.previousStage = result.oldStage;
                if (this.currentAppStatus == 'Pre-Qualification')
                    this.stageNo = '1';
                else if (this.currentAppStatus == 'Online Application')
                    this.stageNo = '2';
                else if (this.currentAppStatus == 'Under Review')
                    this.stageNo = '3';
                else if (this.currentAppStatus == 'Qualifying Tests')
                    this.stageNo = '4';
                else if (this.currentAppStatus == 'Background')
                    this.stageNo = '5';
                 else if (this.currentAppStatus == 'Eligibility List')
                    this.stageNo = '6';
                else if (this.currentAppStatus == 'On Hold')
                    this.stageNo = '7';
                else if (this.currentAppStatus == 'Final Offer')
                    this.stageNo = '8';
                else if (this.currentAppStatus == 'Disqualified-Closed')
                    this.stageNo = '9';

                this.showSpinner = false;
            }).catch(error => {
                console.log('fetchCurrentApplication Error: ', error);
                this.showSpinner = false;
            })
        this.fetchTasks();
        this.previousStatus();
        this.fetchRejectionReason();
    }

    previousStatus(){
        this.showSpinner = true;
        fetchPreviousAppStatus()
            .then(result => {
                console.log('fetch Previous Result: ', result);
                this.previousStage = result;
                this.showSpinner = false;

            })
            .catch(error => {
                console.log(error);
                this.showSpinner = false;
            })

    }

    fetchRejectionReason(){
        this.showSpinner = true;
        fetchRejectionReason()
            .then(result => {
                console.log('fetch Previous Result: ', result);
                this.onHoldReason = result;
                this.showSpinner = false;
            })
            .catch(error => {
                console.log(error);
                this.showSpinner = false;
            })

    }

    fetchTasks() {
        this.showSpinner = true;
        fetchExams()
            .then(result => {
                console.log('fetchExams Result: ', result);
                this.tasks = result.map((obj, index) => ({
                    ...obj,
                    Priority: Priority[obj.Type__c.length % 3],
                    Index: index + 1,
                    Checked: (obj.Status__c && obj.Status__c == 'Pass'),
                    Schedule: (obj.Status__c && obj.Status__c == 'Pending'),
                    ReTake: (obj.Status__c && obj.Status__c =='Fail'),
                    ReSchedule: (obj.Status__c && obj.Status__c =='Registered'),
                    taskTitle:(obj.Type__c =='Written')?'Written Examination':(obj.Type__c =='Physical')?'Physical Examination':'Oral Interview'
                }));
                // this.tasks.forEach(task => {
                //     if(task.Status__c == 'Fail'){
                //         this.notQualified = 'Not Qualified';
                //     }
                // });
                this.showSpinner = false;

            })
            .catch(error => {
                console.log(error);
                this.showSpinner = false;
            })
    }

    handleConfirm(event) {
        let taskId = event.currentTarget.dataset.id;
        let taskDate = new Date(this.template.querySelector(`[data-id="${taskId}"]`).value);
        console.log('taskId: ', taskId, 'tastDate: ', taskDate);
        this.showSpinner = true;
        updateTask({ taskId: taskId, taskDate: taskDate })
            .then(result => {
                console.log(result);
                this.fetchTasks();
                this.showSpinner = false;
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
                this.showSpinner = false;
            })
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
    onClickHandler() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: 'https://psportal.force.com/s/document-upload'
            }
        };
        this[NavigationMixin.Navigate](config);

    }

    //getters
    get stageNoLess() {
        return this.stageNo - 1;
    }
    get isStage2() {
        if (this.stageNo == '2')
            return true;
        return false;
    }
    get isStage3() {
        if (this.stageNo == '3')
            return true;
        return false;
    }
    get isStage4() {
        if (this.stageNo == '4')
            return true;
        return false;
    }
    get isStage5() {
        if (this.stageNo == '5')
            return true;
        return false;
    }
    get isStage6() {
        if (this.stageNo == '7')
            return true;
        return false;
    }
    get isStage7() {
        if (this.stageNo == '8')
            return true;
        return false;
    }
    get isStage8() {
        if (this.stageNo == '9')
            return true;
        return false;
    }
    get isStage9() {
        if (this.stageNo == '6')
            return true;
        return false;
    }
    get isOnlineDisqualified() {
        if(this.previousStage =='Online Application')
            return true;
        return false;
    }
    get isQTDisqualified() {
         if(this.previousStage =='Qualifying Tests')
            return true;
        return false;
    }
    get isBGDisqualified() {
         if(this.previousStage =='Background')
            return true;
        return false;
    }
}