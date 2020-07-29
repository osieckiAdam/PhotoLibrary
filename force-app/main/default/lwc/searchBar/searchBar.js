import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import SEARCHMC from '@salesforce/messageChannel/SearchStarted__c';

export default class SearchBar extends LightningElement {

    @wire(MessageContext)
    messageContext;
    searchKey;


    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.fireSearchStartedEvent();
    }

    fireSearchStartedEvent() {
        const payload = { searchString: this.searchKey }
        publish(this.messageContext, SEARCHMC, payload);
    }
}
