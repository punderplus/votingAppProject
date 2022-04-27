/**
 * Class to get coords for locations
 */ 
public with sharing class LocationCallout {
    /**
     * @description gets coords for location
     * @param  input location without coords
     * @return return location with coords
     */ 
    public Voting_Location__c MakePostCallout(Voting_Location__c loc){
        //http request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String forRequest = loc.Country__c + ', ' + loc.City__c + ', ' + loc.Address__c;
        String encoded = EncodingUtil.urlEncode(forRequest, 'UTF-8');
        request.setEndpoint('https://api.opencagedata.com/geocode/v1/json?q=' + encoded + '&key=9470db79ba054ed7804a9dc5aff67c3a');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        //System.debug(response);
        //parsing http response and adding latitude and longtitude 
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> all = (List<Object>)results.get('results');
            Map<String, Object> annotations = (Map<String, Object>)all[0];
            Map<String, Object> coordList = (Map<String, Object>)annotations.get('annotations');
            Map<String, Object> dms = (Map<String, Object>)coordList.get('DMS');
            System.debug(dms);
            loc.Latitude__c = (String)dms.get('lat');
            loc.Longitude__c = (String)dms.get('lng');
        }
        return loc;
    }
}
