import { LightningElement,wire,track } from 'lwc';
import psPathImg from '@salesforce/resourceUrl/psPathImage';
import { NavigationMixin } from "lightning/navigation";
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import applicationExists from '@salesforce/apex/ContactDocController.applicationExists';
import saveForLaterInstance from '@salesforce/apex/ContactDocController.getSaveForLaterOmniscript';

export default class PsOnlineAppContainer extends NavigationMixin(LightningElement) {
    stagetitle ='Stage Resources';
    faqtitle='Top FAQs';
    submitted = false;

    psPathImg = psPathImg;

    @track name;

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
        applicationExists()
        .then( result =>{
            this.submitted = result;
        })
        .catch();
    }

    onClickHandler(){

        saveForLaterInstance().then(result =>{
            if(result != ''){
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                };
                this[NavigationMixin.Navigate](config);
            } else{
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: '/s/online-application'
                    }
                };
                this[NavigationMixin.Navigate](config);
            }
        })
        .catch(error => {
            console.log(error);
        });

        // const config = {
        //     type: 'standard__webPage',
        //     attributes: {
        //         url: 'https://psportal.force.com/s/online-application'
        //     }
        // };
        // this[NavigationMixin.Navigate](config);
    }
}