import { LightningElement,api,track } from 'lwc';
import getPropertyListingData from '@salesforce/apex/GetPropertyListing.getPropertyListingData';
export default class GetProperty extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;

    disabled = false;
    disableButton() {
    this.disabled = true;
  }
    handleClick(){
            // this.loadingSpinner = true;
            this.disableButton(); 
            getPropertyListingData({subjectPropertyId: this.recordId}).then(resp => {
            // console.log('recordId: '+recordId); 
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
            // this.loadingSpinner = false;
        })
    }
}

