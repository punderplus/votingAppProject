import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

const LOCATION_LATITUDE_FIELD = 'Voting_Location__c.Latitude__c';
const LOCATION_LONGITUDE_FIELD = 'Voting_Location__c.Longitude__c';
const locationFields = [
	LOCATION_LATITUDE_FIELD,
	LOCATION_LONGITUDE_FIELD
];

export default class LocationMap extends LightningElement {
    @api recordId;
    mapMarkers = [];
    @wire(getRecord, { recordId: '$recordId', fields: locationFields })
    loadLocation({ data }) {
        const Latitude = getFieldValue(data, LOCATION_LATITUDE_FIELD);
        const Longitude = getFieldValue(data, LOCATION_LONGITUDE_FIELD);
        this.mapMarkers = [{
                location: { Latitude, Longitude },
            }
        ];
    }
}