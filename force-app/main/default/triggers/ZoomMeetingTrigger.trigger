trigger ZoomMeetingTrigger on Zoom_Meeting__c (after insert, after update,before delete) {

    if(Trigger.isAfter){

        if(Trigger.isInsert){
            ZoomMeetingHandler.handleAfterInsert(Trigger.new);
        }

        if(Trigger.isUpdate){
            ZoomMeetingHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
 
    }
    if(Trigger.isBefore && Trigger.isDelete){
    	ZoomMeetingHandler.HandleBeforeDelete(Trigger.old);
    }
    
}