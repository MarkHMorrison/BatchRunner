/**
 * @description Batch to validate BatchRunnerTriggerHandlerTest.
 *              This batch is only for testing BatchRunnerTriggerHandlerTest.
 * @author Mark H. Morrison
 * @date Tue Nov 6 2018
 */
global class BatchRunnerValidBatch implements Database.Batchable<sObject>, Database.Stateful {
  global Integer recordsProcessed = 0;
  global Integer recordsNotProcessed = 0;
  global String errorMessages = '';
  global String batchQuery;

  global BatchRunnerValidBatch() {
    batchQuery = 'SELECT Id, Name, Description__c FROM Batch_Runner__c WHERE Category__c = \'Misc\'';
    System.debug('constructor batchQuery: ' + batchQuery);
  }

  global Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('start batchQuery: ' + batchQuery);
    return Database.getQueryLocator(batchQuery);
  }

  global void execute(Database.BatchableContext bc, Batch_Runner__c[] scope){
    System.debug('scope: ' + scope);
    for(Batch_Runner__c batchRunner : scope) {
      batchRunner.Description__c = batchRunner.Description__c + ' Updated';
    }
    Database.SaveResult[] saveResults = Database.update(scope,false);
    Integer recordId = 0;
    for(Database.SaveResult saveResult : saveResults) {
      if(!saveResult.isSuccess()) {
        errorMessages += '\n Batch Runner Record Id: ' + scope[recordId].Id;
        for(Database.Error error: saveResult.getErrors()) { errorMessages += '\n - ' + error.getMessage(); }
        recordsNotProcessed++;
      }
      recordsProcessed++;
      recordId++;
    }
  } 

  global void finish(Database.BatchableContext bc){

    AsyncApexJob jobResult = [
      SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ExtendedStatus, CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];
    
    String textBody = '\n\n - Total Job Items: ' + jobResult.TotalJobItems;
    textBody += '\n - Jobs Items Processed: ' + jobResult.JobItemsProcessed;
    textBody += '\n - Number of errors: ' + jobResult.NumberOfErrors;
    if(jobResult.ExtendedStatus != null) { textBody += '\n\n' + jobResult.ExtendedStatus; }
    textBody += '\n\nRecord Counts:';
    textBody += '\n\n - Total: ' + recordsProcessed;
    textBody += '\n - Errors: ' + recordsNotProcessed;
    textBody += '\n' + errorMessages;

    if(Test.isRunningTest()) { System.debug('BatchRunValidBatch textBody: ' + textBody); } 
    else {
      // send email
      // this is only for testing purposes though so won't bother
      // Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
      // emailMessage.setToAddresses(new String[] {'your.name@example.com'});
      // emailMessage.setSubject(UserInfo.getOrganizationName() + ' BatchRunValidBatch status: ' + jobResult.Status);
      // emailMessage.setPlainTextBody(emailMessage.getSubject() + textBody);
      // if(Test.isRunningTest()) {
      //   System.debug(emailMessage.getPlainTextBody());
      // } else {
      //   Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailMessage});
      // }
    }
  }    
}