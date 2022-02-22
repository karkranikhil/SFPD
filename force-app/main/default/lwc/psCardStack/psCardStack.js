import { LightningElement,api } from 'lwc';
import BlogImg1 from '@salesforce/resourceUrl/BlogImg1';
import BlogImg2 from '@salesforce/resourceUrl/BlogImg2';
import BlogImg3 from '@salesforce/resourceUrl/BlogImg3';

export default class PsCardStack extends LightningElement {
    @api title ='Resources';

    BlogImg1=BlogImg1;
    BlogImg2=BlogImg2;
    BlogImg3=BlogImg3;

    get img1(){
        return `background-image: url(${BlogImg1})`
    }

    get img2(){
        return `background-image: url(${BlogImg2})`
    }

    get img3(){
        return `background-image: url(${BlogImg3})`
    }


}