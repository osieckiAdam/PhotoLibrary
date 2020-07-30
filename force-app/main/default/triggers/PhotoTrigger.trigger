trigger PhotoTrigger on Photo__c (before insert, before update) {
    
    for(Photo__c photo : Trigger.new) {
        photo.Title_Trimmed__c = photo.Title__c.abbreviate(27,0);
    }
}