import { LightningElement, wire, api } from 'lwc';
import LASTNAME_FIELD from '@salesforce/schema/User.LastName';
import FIRSTNAME_FIELD from '@salesforce/schema/User.FirstName';
import getModertators from '@salesforce/apex/CampaignController.getModertators';

const COLUMNS = [
    { label: 'Last Name', fieldName: LASTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'First Name', fieldName: FIRSTNAME_FIELD.fieldApiName, type: 'text' },
];

export default class ModeratorsList extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    @wire(getModertators, {cmpId: '$recordId'})
    moderators;
}