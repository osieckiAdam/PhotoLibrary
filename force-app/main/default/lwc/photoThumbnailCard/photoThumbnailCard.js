import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import PHOTOSELECTED from '@salesforce/messageChannel/PhotoSelected__c';

export default class PhotoThumbnailCard extends LightningElement {

    @api
    photo;

    @wire(MessageContext)
    messageContext;

    handleClick() {
        publish(this.messageContext, PHOTOSELECTED, { photoId: this.photo.Id });
    }
}