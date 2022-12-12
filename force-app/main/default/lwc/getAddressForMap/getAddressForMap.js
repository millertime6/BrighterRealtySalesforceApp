import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
// import LATITUDE FROM @salesforce/schema/Property__c.Latitude__c; 
// import LONGITUDE FROM @salesforce/schema/Property__c.Longitude__c; 


export default class LightningMapExample extends LightningElement {
    // @api recordId; 
    // @wire(getRecord,{recordId: '$recordId',fields:[LATITUDE,LONGITUDE]})
    // wireRecord({data,error}){
    //     if(data){
    //         console.log(JSON.stringify(data)); 
    //         coordinates = JSON.stringify(data); 
    //     }
    //     if(error){
    //         console.log(error); 
    //     }
    // }
    mapMarkers = [
        {
            location: {
                Latitude: coordinates.Latitude__c,
                Longitude: coordinates.Longitude__c,
            },
        },
    ];
}