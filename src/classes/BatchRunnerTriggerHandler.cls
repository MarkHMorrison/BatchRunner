/**
 * @description This Apex class handles all logic for the BatchRunnerTrigger allowing batches to be run declaritively.
 * @author Mark H. Morrison.
 * @date Tue Nov 6 2018
 */
public class BatchRunnerTriggerHandler {

  public void beforeUpdate(Batch_Runner__c[] newBatchRunners, Batch_Runner__c[] oldBatchRunners, Map<Id, Batch_Runner__c> newBatchRunnerMap , Map<Id, Batch_Runner__c> oldBatchRunnerMap) {
    Task[] tasks = new Task[]{};
    for(Batch_Runner__c batchRunner : newBatchRunners) {
      if(batchRunner.Execute__c && oldBatchRunnerMap.get(batchRunner.Id).Execute__c != batchRunner.Execute__c && batchRunner.IsActive__c) {
        // set the Execute checkbox back to unchecked
        batchRunner.Execute__c = false;

        Object batchObject = getBatchObject(batchRunner.Name, batchRunner.Batch_Query__c);
        if(batchObject != null) {
          Database.Batchable<sObject> batchableObject = (Database.Batchable<sObject>)batchObject;
          // check to see if we need to run with a different scope
          if(batchRunner.Scope__c > 0) {
            Database.executeBatch(batchableObject, Integer.valueOf(batchRunner.Scope__c));
          } else {
            Database.executeBatch(batchableObject);
          }
          batchRunner.Last_Executed_Date__c = System.now();
          tasks.add(
            new Task(
              Subject = 'Batch Runner: ' + System.now(),
              WhatId  = batchRunner.Id,
              OwnerId = UserInfo.getUserId(),
              Status  = 'Completed'
            )
          );
        }
      }
    }
    if(tasks.size() > 0){
      insert tasks;
    }
  }

  private Object getBatchObject(String batchName, String batchQuery) {
    Type batchType = Type.forName(batchName);
    Object batchObject = null;
    if(batchType != null) {
      if(batchQuery != null) {
        // get default object instance
        Object batchTypeObject = batchType.newInstance();
        // create a JSON string from the serialize default object
        String batchTypeObjectJson = JSON.serialize(batchTypeObject);
        // create a map from the JSON string to get variables available in the batch
        Map<String, Object> batchTypeObjectMap = (Map<String, Object>)JSON.deserializeUntyped(batchTypeObjectJson);
        // update map batchQuery with passed in batchQuery
        if(batchTypeObjectMap.containsKey('batchQuery')) {
          batchTypeObjectMap.put('batchQuery', batchQuery);
        } else {
          // this is only necessary if you have batches previously installed that have an updatable query variable
          // it can also be canged to what ever query variable you use
          batchTypeObjectMap.put('query', batchQuery);
        }
        // create a JSON string from the updated map 
        batchTypeObjectJSON = JSON.serialize(batchTypeObjectMap);
        // create object with JSON string and batchType
        batchObject = JSON.deserialize(
          batchTypeObjectJSON,
          batchType
        );
      } else {
        // no batchQuery so just set the batchObject with a new instance of the batchType
        batchObject = batchType.newInstance();
      }
    } else {
      // batchType was null which means we couldn't find a batch to match the name passed in
      String textBody = '\n\n - Batch Name passed in returned a null Type for batchName: ' + batchName;
      Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
      emailMessage.setToAddresses(new String[]{'your.name@example.com'});
      emailMessage.setSubject(UserInfo.getOrganizationName() + ': BatchRunnerTriggerHandler Batch Runner: ' + batchName + ' Failed');
      emailMessage.setPlainTextBody(emailMessage.getSubject() + textBody);
      if(Test.isRunningTest()) { System.debug(emailMessage.getPlainTextBody()); } 
      else { Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailMessage}); }
    }

    return batchObject;
  }
}