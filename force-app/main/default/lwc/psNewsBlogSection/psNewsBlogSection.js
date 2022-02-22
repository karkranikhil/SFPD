import { LightningElement } from 'lwc';
import NewsImg1 from '@salesforce/resourceUrl/NewsImg1';
import NewsImg2 from '@salesforce/resourceUrl/NewsImg2';
import NewsImg3 from '@salesforce/resourceUrl/NewsImg3';
import { NavigationMixin } from 'lightning/navigation';


export default class PsNewsBlogSection extends NavigationMixin(LightningElement) {
    
    NewsImg1=NewsImg1;
    NewsImg2=NewsImg2;
    NewsImg3=NewsImg3;
    handleClick(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',    
            attributes: {
                pageName: 'public-home'
            }
        });
    }

}