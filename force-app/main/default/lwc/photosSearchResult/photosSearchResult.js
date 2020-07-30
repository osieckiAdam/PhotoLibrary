import { LightningElement, wire, track, api } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import SEARCHMC from '@salesforce/messageChannel/SearchStarted__c';
import sendEmail from '@salesforce/apex/PhotoSearchController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getPhotos from '@salesforce/apex/PhotoSearchController.getPhotos';

export default class PhotosSearchResult extends LightningElement {

    @wire(MessageContext)
    messageContext;

    @wire(getPhotos, { searchProperties: '$searchProps' })
    photos;

    SEARCHKEY = '';
    PAGESIZE = 30;
    PAGENUMBER = 1;

    @track
    searchProps = {
        searchKey: this.SEARCHKEY,
        pageSize: this.PAGESIZE,
        pageNumber: this.PAGENUMBER
    }

    @api record;
    @api muted;
    @api selected;

    searchStartedsubscription;

    connectedCallback() {
        this.searchStartedsubscription = subscribe(
            this.messageContext,
            SEARCHMC,
            (message) => this.handleSearchStarted(message)
        );
    }

    handleSearchStarted(message) {
        this.SEARCHKEY = message.searchString;
        this.searchProps = {
            searchKey: message.searchString,
            pageSize: this.PAGESIZE,
            pageNumber: 1
        }
    }
    handleNextPage() {
        this.PAGENUMBER++;
        this.searchProps = {
            searchKey: this.SEARCHKEY,
            pageSize: this.PAGESIZE,
            pageNumber: this.PAGENUMBER
        }
    }

    handlePreviousPage() {
        this.PAGENUMBER--;
        this.searchProps = {
            searchKey: this.SEARCHKEY,
            pageSize: this.PAGESIZE,
            pageNumber: this.PAGENUMBER
        }
    }

    handleSendEmail(event) {
        sendEmail({
            toAddress: event.detail,
            body: JSON.stringify(this.photos.data.records, undefined, 4)
        })
            .then(() => {
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Your email was sent',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            })
            .catch((error) => {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(event);
            });
    }
}