import { LightningElement } from 'lwc';
import psHomeQulaification from '@salesforce/resourceUrl/psHomeQulaification';
import psHiringProcess from '@salesforce/resourceUrl/psHiringProcess';
import psSalaryBenifits from '@salesforce/resourceUrl/psSalaryBenifits';
import psCommitments from '@salesforce/resourceUrl/psCommitments';
import { NavigationMixin } from "lightning/navigation";

export default class PsSwornJobDetail extends NavigationMixin(LightningElement) {
    psHomeQulaification = psHomeQulaification;
    psHiringProcess = psHiringProcess;
    psSalaryBenifits = psSalaryBenifits;
    psCommitments = psCommitments;

    onclickHandler(){
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/s/demo-page'
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    get img1(){
        return `background-image: url(${psHomeQulaification})`
    }

    get img2(){
        return `background-image: url(${psHiringProcess})`
    }

    get img3(){
        return `background-image: url(${psSalaryBenifits})`
    }

    get img4(){
        return `background-image: url(${psCommitments})`
    }
}