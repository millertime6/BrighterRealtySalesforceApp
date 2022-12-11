import { LightningElement } from 'lwc';
import GetAddressForApexMap from '@salesforce/apex/GetAddressForMap.GetAddressForApexMap';

export default class GetAddressForJSMap extends LightningElement {
    propertyCoordinates = GetAddressForApexMap({propertyId: this.recordId}); 

    mapMarkers = [
        {
            location: {
                Latitude: this.propertyCoordinates[0],
                Longitude: this.propertyCoordinates[1],
            },
        },
    ];

}