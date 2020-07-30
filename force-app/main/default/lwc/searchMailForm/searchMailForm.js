import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import EMAIL_FIELD from '@salesforce/schema/User.Email';

export default class SearchMailForm extends LightningElement {

    error;
    name;
    emailAddress = '';
    isButtonDisabled = false;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [EMAIL_FIELD]
    }) wireuser({ error, data }) {
        if (error) {
            console.log('ERROR: ' + error);
            this.error = error;
        } else if (data) {
            console.log('data: ' + data);
            this.emailAddress = data.fields.Email.value;
            this.template.querySelector('lightning-input.cb').checked = data.fields.Email.value;
        }
    }

    handleSendEmail() {
        this.dispatchEvent(new CustomEvent('sendemail', { detail: this.emailAddress }));
    }

    handleInputChange(event) {
        if (event.target.value != '') {
            this.isButtonDisabled = false;
        } else {
            this.isButtonDisabled = true;
        }
        this.emailAddress = event.target.value;
    }

}