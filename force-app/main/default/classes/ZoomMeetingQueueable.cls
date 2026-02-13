public class ZoomMeetingQueueable implements Queueable, Database.AllowsCallouts {
    private List<Zoom_Meeting__c> records;
    private String operationType;
    public ZoomMeetingQueueable(List<Zoom_Meeting__c> records,String operationType){
        this.records = records;
        this.operationType = operationType;
    }

    public void execute(QueueableContext context){
        if(operationType == 'CREATE'){
            for(Zoom_Meeting__c m : records){
                ZoomIntegration.createMeeting(m);
            }
        }
        else if(operationType == 'CANCEL'){
            for(Zoom_Meeting__c m : records){
                ZoomIntegration.cancelMeeting(m);
            }
        }
        else if(operationType == 'UPDATE'){
            for(Zoom_Meeting__c m: records){
                ZoomIntegration.updateMeeting(m);
			}
        }
    }
}