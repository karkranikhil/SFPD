import { LightningElement,track,wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';

export default class PsOnlineFormHeader extends LightningElement {
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
}