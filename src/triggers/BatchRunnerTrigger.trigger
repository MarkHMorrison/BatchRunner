/**
 * @description This Trigger runs for all Batch_Runner__c inserts and updates.
 * @author Mark H. Morrison.
 * @date Tue Nov 6 2018
 */
trigger BatchRunnerTrigger on Batch_Runner__c (before insert, after insert, before update, after update) {
  BatchRunnerTriggerHandler handler = new BatchRunnerTriggerHandler();
  
  if (Trigger.isBefore) {
    if (Trigger.isUpdate) {
      handler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
    }
  }
}