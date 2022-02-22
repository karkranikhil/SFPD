import { LightningElement } from 'lwc';
import SaveForLateExisting from 'vlocity_ins/omniscriptSaveForLaterAcknowledge';
import tmpl from './customSflAck.html';

export default class CustomSflAck extends SaveForLateExisting {

    render() {
        return tmpl;
    }

    handleBackToHomeButton(){
        window.open('/s','_self');
    }
}