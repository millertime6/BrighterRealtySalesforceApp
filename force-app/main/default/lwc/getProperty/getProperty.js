import { LightningElement,api,wire,track } from 'lwc';
import getPropertyListingData from '@salesforce/apex/GetPropertyListing.getPropertyListingData';
import LightningAlert from 'lightning/alert';
export default class GetProperty extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;


    // handle_Id(event) {
    //     this.recordId = event.detail.value;
    // }

    handleClick(){
            // this.loadingSpinner = true;
            getPropertyListingData({subjectPropertyId: this.recordId}).then(resp => {
            // console.log('recordId: '+recordId); 
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
            // this.loadingSpinner = false;
        })
    }
    handleMobileChange(event){
        this.mobilevalue = event.target.value;
    } 

    handleNext() {
        
    }

    async handleCancel(){

            await LightningAlert.open({
            message: 'this is the alert message',
            theme: 'error', 
            label: 'Error!', 
            variant: 'header',
        });
    }
}

