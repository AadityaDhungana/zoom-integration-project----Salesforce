public class ZoomIntegration {
    public static void createMeeting(Zoom_Meeting__c meeting){
        WrapperMeeting payload = new WrapperMeeting();
        payload.topic = meeting.Topic__c;
        payload.type = 2;
        payload.start_time = meeting.Start_Time__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        payload.duration = Integer.valueOf(meeting.Duration__c);
        payload.timezone = meeting.Time_Zone__c;
        
        String jsonBody = JSON.serialize(payload);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('callout:Zoom_Integration/v2/users/me/meetings');
        req.setBody(jsonBody);
        sendRequest(req, meeting.Id, 'CREATE');
    }

    public static void cancelMeeting(Zoom_Meeting__c meeting){
        if(String.isBlank(meeting.Zoom_Meeting_Id__c)){
            return;
        }
        HttpRequest req = new HttpRequest();
        req.setMethod('DELETE');
        req.setEndpoint('callout:Zoom_Integration/v2/meetings/' +meeting.Zoom_Meeting_Id__c);
        sendRequest(req, meeting.Id, 'CANCEL');
    }
	
    public static void updateMeeting(Zoom_Meeting__c meeting){
        WrapperMeeting payload = new WrapperMeeting();
        payload.topic = meeting.Topic__c;
        payload.start_time = meeting.Start_Time__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        payload.duration = Integer.valueOf(meeting.Duration__c);
        payload.timezone = meeting.Time_Zone__c;
    
        String jsonBody = JSON.serialize(payload);
        HttpRequest req = new HttpRequest();
        req.setMethod('PATCH');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('callout:Zoom_Integration/v2/meetings/' + meeting.Zoom_Meeting_Id__c);
        req.setBody(jsonBody);
        sendRequest(req, meeting.Id, 'UPDATE');
    }
    private static void sendRequest(HttpRequest req, Id recordId, String operationType){
        Http http = new Http();
        HttpResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        if(statusCode == 201 && operationType == 'CREATE'){
            Map<String,Object> responseMap =(Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            update new Zoom_Meeting__c(
                Id = recordId,
                Zoom_Meeting_Id__c = String.valueOf(responseMap.get('id')),
                Join_URL__c = String.valueOf(responseMap.get('join_url')),
                Status__c = 'Scheduled'
            );
        }
        else if(statusCode == 204 && operationType == 'CANCEL'){
            update new Zoom_Meeting__c(Id = recordId,Status__c = 'Cancelled');
        }
        else if(statusCode == 204 && operationType == 'UPDATE'){
            update new Zoom_Meeting__c(Id = recordId,Status__c = 'Scheduled');
        }
        else{
            update new Zoom_Meeting__c(Id = recordId,Status__c = 'Failed');
        }
	}

    public class WrapperMeeting {
        public String topic;
        public Integer type;
        public String start_time;
        public Integer duration;
        public String timezone;
    }
}