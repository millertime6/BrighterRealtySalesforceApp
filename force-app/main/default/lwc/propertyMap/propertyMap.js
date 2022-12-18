import { LightningElement, api, wire, track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const fieldsArray = [
    "Property__c.Latitude__c",
    "Property__c.Longitude__c",
    "Property__c.Name"
]; 
export default class PropertyMap extends LightningElement {
    
    //wire function fetches details from above 
    @api recordId; 
    @track mapMarkers = []; 

    latitude; 
    longitude; 
    propertyName; 

    @wire(getRecord,{recordId : "$recordId",fields: fieldsArray})
    wiredRecord({error,data}){
        if(data){
            JSON.stringify(data); 
            this.latitude = data.fields.Latitude__c.value; 
            this.longitude = data.fields.Longitude__c.value; 
            this.propertyName = data.fields.Name.value; 

            const marker = {
                location: {
                    Latitude: this.latitude,
                    Longitude: this.longitude,
                },
                Title: this.propertyName ? this.propertyName : ''
            }; 
            this.mapMarkers = [marker]; 
            this.error = undefined; 
        }else if(error){
            this.mapMarkers = undefined; 
            this.error = error; 
        }
    }
}