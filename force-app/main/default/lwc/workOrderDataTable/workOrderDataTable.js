import { LightningElement, wire } from 'lwc';
import getWorkOrders from '@salesforce/apex/GetWorkOrders.getWorkOrders';

const columns = [
    { label: 'Due Date', fieldName: 'Due_Date__c' },
    { label: 'Project', fieldName: 'Project__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Vendor', fieldName: 'Vendor__c' },
    { label: 'Work Order Name', fieldName: 'Name' },
];
export default class WorkOrderDataTable extends LightningElement {
    error;
    columns = columns;

    @wire(getWorkOrders)
    Work_Order__c;
}