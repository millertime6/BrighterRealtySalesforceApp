import { LightningElement,api,wire,track } from 'lwc';
import getSaleAndMortgage from '@salesforce/apex/GetSaleAndMortgage.getSaleAndMortgage';
import LightningConfirm from 'lightning/confirm';

export default class getSaleMortgage extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;

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
            this.disableButton(); 
            this.handleCancel(); 
            getSaleAndMortgage({subjectPropertyId: this.recordId}).then(resp => {
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
        })
    }
}