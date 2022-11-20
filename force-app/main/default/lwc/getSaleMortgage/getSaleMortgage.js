import { LightningElement,api,wire,track } from 'lwc';
import getSaleAndMortgage from '@salesforce/apex/GetSaleAndMortgage.getSaleAndMortgage';

export default class getSaleMortgage extends LightningElement {
    @api recordId; 
    @track data;
    @track isShowModal = false;


    handleClick(){
            // this.loadingSpinner = true;
            getSaleAndMortgage({subjectPropertyId: this.recordId}).then(resp => {
            this.data = JSON.parse(resp).message;
            console.log(this.data[0]); 
        })
    }
}