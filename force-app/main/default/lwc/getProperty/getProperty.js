import { LightningElement,api,track } from 'lwc';
import getPropertyListingData from '@salesforce/apex/GetPropertyListing.getPropertyListingData';
import LightningConfirm from 'lightning/confirm';

export default class GetProperty extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;

    disabled = false;
    disableButton() {
    this.disabled = true;
  }

  handleNext() {
    alert('Your request is processing. Please do not press the button again and refresh your screen. ');        
}
    async handleCancel(){

      const result = LightningConfirm.open({
          message: 'Your request is processing. You do not need to press the button again and please make sure to refresh your screen in a few seconds.',
          variant: 'header',
          label: 'Request Received',
          theme: 'error',
      });
  }
    handleClick(){
            this.handleCancel(); 
            this.disableButton(); 
            getPropertyListingData({subjectPropertyId: this.recordId}).then(resp => {
            // console.log('recordId: '+recordId); 
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
            // this.loadingSpinner = false;
        })
    }
}

