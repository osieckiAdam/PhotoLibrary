import { LightningElement, wire, track, api } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import SEARCHMC from '@salesforce/messageChannel/SearchStarted__c';
import sendEmail from '@salesforce/apex/PhotoSearchController.sendEmail';

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

    get cssClass() {
        return (
            'slds-box slds-box_xx-small es-tile' +
            (this.muted ? ' muted' : '') +
            (this.selected ? ' selected' : '')
        );
    }

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
        console.log('SEARCH STARTED, MESSAGE: ' + message.searchString);

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
            toAddress: event.mailAddress,
            body: JSON.stringify(this.photos.data.records)
        })
        // .then(() => {
        //     console.log('Email sent successfully');
        // })
        // .catch((error) => {
        //     console.log(error.body.message);
        // });
    }
}