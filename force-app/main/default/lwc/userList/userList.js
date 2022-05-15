import { LightningElement, track, api, wire } from 'lwc';
import getModertators from '@salesforce/apex/CampaignController.getModertators';
import getAvailableUsers from '@salesforce/apex/AvailableUsersSelector.getAvailableUsers';

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

    connectedCallback() {
        getModertators({ cmpId: this.recordId, lim: 5, userType: this.componentLabel }).then(response => {
            //different table lable for different componentLabel arguement
            if (this.componentLabel === "MODER") {
                this.listName = "Moderators";
            }
            else if (this.componentLabel === "VOTER") {
                this.listName = 'Voters';
            }
            else if (this.componentLabel === "ANLTC") {
                this.listName = 'Analytics';
            }
            else if (this.componentLabel === "CONFG") {
                this.listName = 'Configurators';
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
    //filling in options list
    options = [];
    @wire(getAvailableUsers, { cmpId: '$recordId', userType: '$componentLabel' })
    wiredUsers({ error, data }) {
        if (data) {
            data.forEach(item => this.options.push({ 'value': item.Id, 'label': item.Name }));
        } else if (error) {
            this.error = error;
            this.options = undefined;
        }
    }
    values = [];

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