import { LightningElement, track } from 'lwc';

import fetchAllApplications from '@salesforce/apex/ContactDashboardController.fetchAllApplications';
import updateContact from '@salesforce/apex/ContactDashboardController.updateContact';
import getResumeURL from '@salesforce/apex/ContactDashboardController.getResumeURL';
import { NavigationMixin } from "lightning/navigation";

export default class PsDashboard extends NavigationMixin(LightningElement) {
    @track applications = [];
    showSpinner = false;

    connectedCallback(){
        fetchAllApplications()
        .then(result => {
            this.applications = JSON.parse(result);
            console.log(result);

            function compare( a, b ) {
            if ( a.applicationName > b.applicationName ){
            return -1;
            }
            if ( a.applicationName < b.applicationName ){
            return 1;
            }
            return 0;
            }

            console.log(this.applications.sort( compare ));

            this.applications.forEach(application => {
                if(application.applicationStatus == 'Disqualified-Closed'){
                    //application.cssproperty = 'slds-text-color_error';
                    application.cssproperty = 'color:red;';
                }
                else if(application.applicationStatus == 'Final Offer'){
                    //application.cssproperty = 'slds-text-color_success';
                    application.cssproperty = 'color:#32cd32';
                }
                else{
                    //application.cssproperty = 'slds-text-color_weak';
                    application.cssproperty = 'color:#Cd7f32;';
                }
            });
        })
        .catch(error => {
            console.log(error);
        })
    }

    goToApplication(event){
        //this.showSpinner = true;
        console.log('Go To Application clicked ',event.target.value);
        let appID = this.applications[event.target.value].applicationId;
        updateContact({
            appId: appID,
            appStatus: this.applications[event.target.value].applicationStatus
        }).then(result => {
            //this.showSpinner = false;
            console.log('updateContact Result: ',result);
            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: '/s/view-application?applicationId='+appID
                }
            };
            this[NavigationMixin.Navigate](config);
            // window.open("https://psportal.force.com/s/view-application?applicationId="+appID, "_self");
        }).catch(error => {
            this.showSpinner = false;
            console.log('updateContact error: ',error);
        })
    }

    resumeApplication(event){
        
        console.log('Resume Application clicked', event.target.value);
        // getResumeURL({
        //     appId: this.applications[event.target.value].Id
        // }).then(result => {
        //     console.log('getResumeURL result: ',result);
        //     window.open(result, "_self");
        // }).catch(error => {
        //     console.log('getResumeURL error: ',error);
        // })

        let app = this.applications[event.target.value];
        window.open(app.resumeURL, "_self");

    }

    startApplication(event){
        console.log('Resume Application clicked', event.target.value);

        let applId = this.applications[event.target.value].applicationId;

        window.open('/s/online-application?applicationId='+applId, "_self");
    }

    get showError(){
        return this.applications.length == 0;
    }


    activeSectionMessage = '';

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    handleSetActiveSectionC() {
        const accordion = this.template.querySelector('.example-accordion');

        accordion.activeSectionName = 'C';
    }


    /*onclickHandler(){
            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: 'https://psportal.force.com/s/public-home'
                }
            };
            this[NavigationMixin.Navigate](config);
    }*/
    onBtnclickHandler(){
         const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/s/demo-page'
            }
        };
        this[NavigationMixin.Navigate](config);
    }
}