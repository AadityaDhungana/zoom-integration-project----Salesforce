public class ZoomMeetingHandler {

    public static void handleAfterInsert(List<Zoom_Meeting__c> newRecords){
        System.enqueueJob(new ZoomMeetingQueueable(newRecords, 'CREATE'));
    }

    public static void handleAfterUpdate(List<Zoom_Meeting__c> newRecords,Map<Id, Zoom_Meeting__c> oldMap){
        List<Zoom_Meeting__c> toCancel = new List<Zoom_Meeting__c>();
        List<Zoom_Meeting__c> toUpdate = new List<Zoom_Meeting__c>();
        for(Zoom_Meeting__c rec : newRecords){
            Zoom_Meeting__c oldRec = oldMap.get(rec.Id);
            if(rec.Status__c == 'Cancelled' && oldRec.Status__c != 'Cancelled'){
                toCancel.add(rec);
            }
            else{
                toUpdate.add(rec);
            }
        }
        if(!toCancel.isEmpty()){
            System.enqueueJob(new ZoomMeetingQueueable(toCancel, 'CANCEL'));
        }
        if(!toUpdate.isEmpty()){
            System.enqueueJob(new ZoomMeetingQueueable(toUpdate,'UPDATE'));
        }
    }
    
    public static void handleBeforeDelete(List<Zoom_Meeting__c> oldRecords){
        for(Zoom_Meeting__c rec : oldRecords){
            if(rec.isAvailable__c){
                rec.addError('Active Meetings cannot be deleted.');
            }
        }
    }
}