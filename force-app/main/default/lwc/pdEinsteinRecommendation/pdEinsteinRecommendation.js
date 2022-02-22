import { LightningElement,api } from 'lwc';
// import myResource from '@salesforce/resourceUrl/resourceReference';

export default class PdEinsteinRecommendation extends LightningElement {
    @api score;
    @api scoreLabel;
    @api labelFirst;
    @api labelSecond;

    @api firstSection1;
    @api firstSection2;
    @api firstSection1Value;
    @api firstSection2Value;
    @api firstSectionAValue;
    @api firstSectionA;
    @api secondSection1;
    @api secondSection1Value;
    @api heading;
    // @api secondSection1Value;
    // @api firstSection1;
}