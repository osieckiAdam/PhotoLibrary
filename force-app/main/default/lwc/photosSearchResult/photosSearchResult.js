import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import SEARCHMC from '@salesforce/messageChannel/SearchStarted__c';

export default class PhotosSearchResult extends LightningElement {

    @wire(MessageContext)
    messageContext;

    searchStartedsubscription;

    connectedCallback() {
        this.searchStartedsubscription = subscribe(
            this.messageContext,
            SEARCHMC,
            (message) => this.handleSearchStarted(message)
        );
    }

    handleSearchStarted(message) {
        console.log('SEARCH STARTED, MESSAGE: ' + Object.entries(message.searchString));
    }
}