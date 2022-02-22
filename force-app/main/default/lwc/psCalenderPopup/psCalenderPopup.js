import { api, LightningElement, track } from 'lwc';

export default class PsCalenderPopup extends LightningElement {
    @api selectedItem;
    @track isWritten = false;
    @track isPhysical = false;
    @track isInterview = false;
    @track isModalOpen = false;
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isWritten = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isWritten = false;
    }
    connectedCallback(){
        console.log('selectedItem :>> ', this.selectedItem);
        if(this.selectedItem === 'Written'){
            this.isWritten = true;
        }
        else if(this.selectedItem === 'Physical'){
            this.isPhysical = true;
        }
        else if(this.selectedItem === 'Interview'){
            this.isInterview = true;
        }
    }
}