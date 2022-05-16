import { LightningElement, track, api, wire } from 'lwc';
import getUsers from '@salesforce/apex/CampaignController.getUsers';
import getAllAvailableUsers from '@salesforce/apex/UsersToEditController.getAllAvailableUsers';
import getCurrentUsers from '@salesforce/apex/UsersToEditController.getCurrentUsers';

//columns for the table
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
    //type of user (VOTER, MODER, ANLTC, CONFG)
    @api componentLabel;
    //id of current record
    @api recordId;
    //should list be editable
    @api editable;
    //list of users of current type
    @track users;
    //columns
    columns = COLUMNS;

    //name of list shown to user
    listName;
    //recordType name
    recordTp;
    connectedCallback() {
        getUsers({ cmpId: this.recordId, lim: 5, userType: this.componentLabel }).then(response => {
            //different table lable for different componentLabel arguement
            if (this.componentLabel === "MODER") {
                this.listName = "Moderators";
                this.recordTp = "Moderator";
            }
            else if (this.componentLabel === "VOTER") {
                this.listName = "Voters";
                this.recordTp = "Voter";
            }
            else if (this.componentLabel === "ANLTC") {
                this.listName = "Analytics";
                this.recordTp = "Analytic";
            }
            else if (this.componentLabel === "CONFG") {
                this.listName = 'Configurators';
                this.recordTp = 'Configurator';
            }
            //adding links to profiles
            this.users = response;
            this.users.forEach(item => {
                item.UserURL = '/' + item.Id;
            });
        }).catch(error => {
            console.log('Error: ' + error);
        });
    }
    @track options = [];
    @track values = [];
    //filling in options list
    @wire(getAllAvailableUsers, { cmpId: '$recordId', recordTp: '$recordTp' })
    wiredUsers({ error, data }) {
        if (data) {
            data.forEach(item => this.options.push({ 'label': item.Name, 'value': item.Id }));
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    }

    //filling in values list
    @wire(getCurrentUsers, { cmpId: '$recordId', recordTp: '$recordTp' })
    wiredUsersIn({ error, data }) {
        if (data) {
            data.forEach(item => this.values.push(item.User__r.Id));
        } else if (error) {
            this.error = error;
            this.values = undefined;
        }
    }
    //detects if edit window is open
    @track isEditOpen = false;

    openEdit() {
        this.isEditOpen = true;
    }
    closeEdit() {
        this.isEditOpen = false;
    }
    submitEdit() {
        this.isEditOpen = false;
    }

}