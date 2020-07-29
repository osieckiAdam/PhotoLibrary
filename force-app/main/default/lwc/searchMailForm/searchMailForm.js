import { LightningElement } from 'lwc';
import sendEmail from '@salesforce/apex/PhotoSearchController.sendEmail';

export default class SearchMailForm extends LightningElement {

    emailAddress;

    handleSendEmail() {
        this.dispatchEvent(new CustomEvent('sendemail', { detail: this.emailAddress }));
    }

    handleInputChange(event) {
        this.emailAddress = event.target.value;
    }

}