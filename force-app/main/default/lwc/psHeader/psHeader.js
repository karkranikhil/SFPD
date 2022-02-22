import { LightningElement, wire, track } from 'lwc';
import isguest from '@salesforce/user/isGuest';
import mtxLogoImage from '@salesforce/resourceUrl/pslogonew';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
//import fetchUserImage from '@salesforce/apex/ContactDocController.fetchUserImage';
// import profilePic from '@salesforce/resourceUrl/headerImage';
import basePath from "@salesforce/community/basePath";
import { NavigationMixin } from 'lightning/navigation';

export default class PsHeader extends NavigationMixin(LightningElement){
    isFull = isguest;
    // image = profilePic;
    @track name;
    @track baseURL = window.location.origin;
    @track imageUrl = '';
    
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

    logo = mtxLogoImage;

    handleLogin() {
        window.open('/s/login', '_self');
    }

    logoutLink() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        window.open(sitePrefix + "/secur/logout.jsp", '_self');
    }
    navigateToHome() {
        console.log ('>>IN ');
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',    
            attributes: {
                pageName: 'home'
            }
        });
    }

    
}