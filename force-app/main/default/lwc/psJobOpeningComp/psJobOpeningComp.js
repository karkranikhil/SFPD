import { LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
export default class PsJobOpeningComp extends NavigationMixin(LightningElement)  {
    
    activeSectionMessage = '';

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    handleSetActiveSectionC() {
        const accordion = this.template.querySelector('.example-accordion');

        accordion.activeSectionName = 'C';
    }


    onclickHandler(){
            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: '/s/public-home'
                }
            };
            this[NavigationMixin.Navigate](config);
    }
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