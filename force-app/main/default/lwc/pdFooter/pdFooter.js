import { LightningElement, track } from 'lwc';
import facebookIcon from '@salesforce/resourceUrl/facebook_Icon'
import twitterIcon from '@salesforce/resourceUrl/TwitterIcon';
import homeIcon from '@salesforce/resourceUrl/homeIcon';
import vineIcon from '@salesforce/resourceUrl/vine';
import instaIcon from '@salesforce/resourceUrl/instaIcone';

export default class PdFooter extends LightningElement {
    @track fIcon = facebookIcon;
    @track tIcon = twitterIcon;
    @track hIcon = homeIcon;
    @track iIcon = instaIcon;
    @track vIcon = vineIcon;
}