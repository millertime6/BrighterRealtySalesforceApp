import { LightningElement,api,track } from 'lwc';
import getPropertyListingData from '@salesforce/apex/GetPropertyListing.getPropertyListingData';
export default class GetProperty extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;

    handleClick(){
            // this.loadingSpinner = true;
            getPropertyListingData({subjectPropertyId: this.recordId}).then(resp => {
            // console.log('recordId: '+recordId); 
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
            // this.loadingSpinner = false;
        })
    }
}

