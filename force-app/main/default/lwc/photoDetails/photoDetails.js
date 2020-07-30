import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import PHOTOSELECTED from '@salesforce/messageChannel/PhotoSelected__c';
import { getRecord } from 'lightning/uiRecordApi';

import URL_FIELD from '@salesforce/schema/Photo__c.Url__c';
import ALBUM_FIELD from '@salesforce/schema/Photo__c.Album_Id__c';
import TITLE_FIELD from '@salesforce/schema/Photo__c.Title__c';
import EXTERNALID from '@salesforce/schema/Photo__c.External_Id__c';
import TITLETRIMED from '@salesforce/schema/Photo__c.Title_Trimmed__c';


export default class PhotoDetails extends LightningElement {

    @wire(MessageContext)
    messageContext;
    photoSelectedSubscription;

    photo;
    url;
    title;
    albumId;
    externalId;
    titleTrimmed;

    @wire(getRecord, { recordId: '$recordId', fields: [URL_FIELD, ALBUM_FIELD, TITLE_FIELD, EXTERNALID, TITLETRIMED] })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            console.log('DATA: ' + data);
            this.photo = data;
            this.url = this.photo.fields.Url__c.value;
            this.title = this.photo.fields.Title__c.value;
            this.albumId = this.photo.fields.Album_Id__c.value;
            this.externalId = this.photo.fields.External_Id__c.value;
            this.titleTrimmed = this.photo.fields.Title_Trimmed__c.value;
        }
    }

    recordId

    connectedCallback() {
        this.photoSelectedSubscription = subscribe(
            this.messageContext,
            PHOTOSELECTED,
            (message) => this.handlePhotoSelected(message)
        );
    }
    handlePhotoSelected(message) {
        this.recordId = message.photoId;
    }



}