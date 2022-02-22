import { LightningElement, track, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import fetchCurrentApplication from '@salesforce/apex/ContactDashboardController.fetchCurrentApplication';
import fetchOverallAppStatus from '@salesforce/apex/ContactDashboardController.fetchOverallAppStatus';
import psApplicationBanner from '@salesforce/resourceUrl/psApplicationBanner';
import { CurrentPageReference } from 'lightning/navigation';

export default class PsApplicationBanner extends LightningElement {
    @track name;
    @track currentPage;
    @track stageNo = '';
    @track currentAppStatus;
    @track overallAppStatus;
    @track prevAppStatuses = [
        'NIL',
        'Pre-Qualification',
        'Online Application',
        'Under Reveiw',
        'Qualifying Tests',
        'Background',
        'Eligibility List',
        'On Hold',
        'Final Offer',
        'Disqualified-Closed'
    ];
    @track prevAppStatus;
    get backgroundStyle() {
        return `background: linear-gradient(90deg, rgba(40, 135, 236, 0.8) -0.93%, rgba(40, 135, 236, 0) 99.61%), url(${psApplicationBanner});
                height: 200px; background-size: cover`;
        //return `background-image:url(${psHomePageBanner})`;
    }
    connectedCallback() {
        var url_parm = window.location.href;
        if(url_parm.length < 26){
            this.dashboardShow = true;
        }
        else{
            this.dashboardShow = false;
        }
        console.log('dashboardShow :>> ', this.dashboardShow);
    }
    connectedCallback() {
        this.showSpinner = true;
        fetchCurrentApplication()
            .then(result => {
                console.log('fetchCurrentApplication Result: ', result);
                this.currentAppStatus = result;
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
                this.prevAppStatus = this.prevAppStatuses[this.stageNo];
                this.fetchOverallAppStatus();

                this.showSpinner = false;
            }).catch(error => {
                console.log('fetchCurrentApplication Error: ', error);
                this.showSpinner = false;
            })
    }

    fetchOverallAppStatus(){
        fetchOverallAppStatus()
            .then(result => {
                console.log('fetchOverallAppStatus Result: ', result);
                this.overallAppStatus = result;
            }).catch(error =>{
                console.log('fetchOverallAppStatus Error: ', error);
            })
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.currentPage = currentPageReference.attributes.name;
          console.log('CurrentPage: ', this.currentPage);
       }
    }

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
    
    get showDashboard(){
        if (this.currentPage == 'Home')
            return true;
        return false;
    }
    get showInterestForm(){
        if(this.currentPage == 'Demo_page__c')
            return true;
        return false;
    }
    get showOnlineApplication(){
        if(this.currentPage == 'Online_Application__c')
            return true;
        return false;
    }
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
        if (this.stageNo == '6')
            return true;
        return false;
    }
    get isStage7() {
        if (this.stageNo == '7')
            return true;
        return false;
    }
    get isStage8() {
        if (this.stageNo == '8')
            return true;
        return false;
    }
}