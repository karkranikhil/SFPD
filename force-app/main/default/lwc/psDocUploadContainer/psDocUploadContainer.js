import { LightningElement,wire,track } from 'lwc';
import greenTickImg from '@salesforce/resourceUrl/psGreenTickImg';
import saveAttachments from '@salesforce/apex/ContactDocController.saveAttachments';
import fecthConId from '@salesforce/apex/ContactDocController.fetchContactId';
import updateContactAndTask from '@salesforce/apex/ContactDocController.updateContactAndTask';
import fetchAllBGDocs from '@salesforce/apex/ContactDocController.fetchAllBGDocs';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';
import USER_ID from '@salesforce/user/Id';
import { NavigationMixin } from "lightning/navigation";
import { updateRecord } from 'lightning/uiRecordApi';
import STAGE_FIELD from '@salesforce/schema/Contact.Candidate_Stage__c';
import DOCUPLOAD_FIELD from '@salesforce/schema/Contact.Document_Uploaded__c';
import ID_FIELD from '@salesforce/schema/Contact.Id';
import { CurrentPageReference } from 'lightning/navigation';
import removeAttachments from '@salesforce/apex/ContactDocController.removeAttachments';

export default class PsDocUploadContainer extends NavigationMixin(LightningElement) {
    
    greenCheckImg=greenTickImg;
    uploadFileName ='';
    ConVersionID ='';
    showImg;
    UserId = USER_ID;
    recordId;
    taskId;
    applicationId;
    currentPageReference = null; 
    @track bgDocs = [];
    @track currentDocName;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          console.log(currentPageReference.state.taskId)
          this.taskId = currentPageReference.state.taskId
          this.applicationId = currentPageReference.state.applicationId
       }
    }

    connectedCallback(){
        fecthConId({UserId : this.UserId})
        .then((result) =>{
            console.log(result);
            this.recordId =result;
             console.log('OUTPUT ',this.recordId);
            this.error = undefined;
        })
        .catch((error)=>{
            console.log(error);
             console.log('OUTPUT ERROR',this.recordId);
            this.error = error;
            this.recordId='';

        })
        this.fetchBGDocs();
    }

    uploadFileName2 ='';
    showImg2;

    

    get acceptedFormats() {
        return ['.pdf', '.jpg','.jpeg'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        let dataset = event.currentTarget.dataset;
        console.log(dataset.name)
        this.handleAttachment(uploadedFiles[0].contentVersionId,dataset.name);
    }

    handleUploadFinished2(event) {
        const uploadedFiles = event.detail.files;
        this.uploadFileName2 = uploadedFiles[0].name;
        this.showImg2 =true;
        this.handleAttachment(uploadedFiles[0].contentVersionId,'Social Security Card');
    }

    handleAttachment(ConDocVer,DocId){
        saveAttachments({UserId : this.UserId, ConVerId:ConDocVer, DocId:DocId})
        .then((result) => {
            console.log('Result',result);
            this.error =undefined;
        })
        .catch((error) => {
            this.error =error;
            console.log('Error',error);
        })
        this.fetchBGDocs();
    }

    handleUpdate(event){
        //const fields = event.detail.fields;
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
        console.log('Event Fired');
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        
        //fields[STAGE_FIELD.fieldApiName] = 'On Hold';
        fields[DOCUPLOAD_FIELD.fieldApiName] = true; 
        const record = { fields };
        updateRecord(record).then(data => {
            updateContactAndTask({taskId:this.taskId})
                .then( res => {
                    console.log(res)
                    const config = {
                        type: 'standard__webPage',
                        attributes: {
                            url: '/s/view-application?applicationId='+this.applicationId
                        }
                    };
                    this[NavigationMixin.Navigate](config);
                })
                .catch(error => {
                    console.log(error);
                    if (error.body && error.body.message){
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        }));
                    }
                })
        })
        .catch(error => {
            console.log(error);
        })
       

    }

    handleConsentFormDownload() {
        window.open('https://mtxpsdemo.my.salesforce.com/sfc/p/5f000005uWQU/a/5f000000bmLO/ll51wc5rxKe3UxhGCNzDG3SnFdF79yB.TBLfzer5d3g');
    }
    handleAuthFormDownload() {
        window.open('https://mtxpsdemo.my.salesforce.com/sfc/p/5f000005uWQU/a/5f000000bmP1/dX49cZ2lmTDehCfNIZ_gjytoKP2V0ef8PT.zRya3GpQ');
    }

    handleDownload(event) {
        const sitePrefix = basePath.replace(/\/s$/i,'');
        window.open(sitePrefix + ('/sfc/servlet.shepherd/document/download/' + event.currentTarget.dataset.name));
    }

    handleDelete(event) {
        console.log('LOG',event.currentTarget.dataset.name);
        removeAttachments({ConVerId:event.currentTarget.dataset.name})
        .then(() =>{
            console.log('Deleted Attachment');
            this.fetchBGDocs();
        })
        .catch( error => {
            console.log(error)
        })
    }

    fetchBGDocs(){
        fetchAllBGDocs({taskId:this.taskId})
        .then( result => {
            this.bgDocs = result.map((obj,index)=> ({ ...obj, 
            isAuthofInfo: (obj.Name == 'Authorization of Release for Information'),
            isAuthofConCred :(obj.Name == 'Authorization of Release for Consumer Credit Report'),
         }));
        })
        .catch( error => {
            console.log(error)
        })
    }

}