import { LightningElement,api,wire,track } from 'lwc';
import getPropertyListingData from '@salesforce/apex/GetPropertyListing.getPropertyListingData';

export default class GetProperty extends LightningElement {
    @api recordId; 
    handle_Id(event) {
        this.recordId = event.detail.value;
    }
    handleClick(){
            this.loadingSpinner = true;
            getPropertyListingData({recordId}).then(resp => {
            console.log('recordId: '+recordId); 
            this.data = JSON.parse(resp);
            console.log(this.data); 
            this.loadingSpinner = false;
        })
    }
}

//c/getPropertytesting