import { LightningElement, api } from 'lwc';
import psHomePageBanner from '@salesforce/resourceUrl/psHomePageBanner';
import { NavigationMixin } from "lightning/navigation";
export default class PsHomePageBanner extends NavigationMixin(LightningElement) {
    @api isbtnreq;
    imageUrl = psHomePageBanner;

    onclickHandler() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: '/s/demo-page'
            }
        };
        this[NavigationMixin.Navigate](config);
    }
    get backgroundStyle() {
        return `background-image:url(${psHomePageBanner}); background-size: cover; position: relative`;
    }
    connectedCallback() {
        console.log('imageurl :>> ', this.backgroundStyle);

    }
}