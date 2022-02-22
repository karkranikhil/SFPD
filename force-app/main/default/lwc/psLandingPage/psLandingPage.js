import { LightningElement } from 'lwc';
import psHomePageBanner from '@salesforce/resourceUrl/psHomePageBanner';
export default class PsLandingPage extends LightningElement {
    faqtitle ='Top FAQs';
    imageUrl = psHomePageBanner;

    get backgroundStyle() {
        return `background-image:url(${psHomePageBanner})`;
    }
    connectedCallback() {
        console.log('imageurl :>> ', this.backgroundStyle);

    }
}