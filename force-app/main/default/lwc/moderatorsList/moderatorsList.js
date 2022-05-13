import { LightningElement, track, api } from 'lwc';
//import NAME_FIELD from '@salesforce/schema/User.Name';
//import USERNAME_FIELD from '@salesforce/schema/User.UserName';
import getModertators from '@salesforce/apex/CampaignController.getModertators';

const COLUMNS = [
    {
        label: 'Name', fieldName: "UserURL", type: 'url',
        typeAttributes: {
            label: {
                fieldName: "Name"
            },
            target: '_blank'
        }
    },
    {
        label: 'Username',
        fieldName: 'Username',
        type: 'text'
    }
];

export default class ModeratorsList extends LightningElement {
    @api recordId;
    @track moderators;
    columns = COLUMNS;

    connectedCallback() {
        getModertators({ cmpId: this.recordId }).then(response => {
            this.moderators = response;
            this.moderators.forEach(item => {
                item.UserURL = '/lightning/r/User/' + item.Id + '/view';
            });
        }).catch(error => {
            console.log(error);
        });
    }
}