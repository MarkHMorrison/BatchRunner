/**
 * @description Test class for BatchRunnerTriggerHandler class.
 * @author Mark H. Morrison 
 * @date Tue Nov 6 2018
 */
@isTest
private class BatchRunnerTriggerHandlerTest {

  @testSetup
  private static void setup(){
    // Create BatchRun then update it to run
    Batch_Runner__c testBatchRunner = new Batch_Runner__c(
      Name           = 'BatchRunnerValidBatch',
      Description__c = 'Test BatchRunner',
      Category__c    = 'Misc'
    );
    insert testBatchRunner;
    System.assertNotEquals(null, testBatchRunner.Id, 'Insert testBatchRunner failed');
  }

  @isTest
  private static void testBatchRunnerTriggerHandler() {
    Batch_Runner__c preBatchRunner = [SELECT Id, Execute__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];
    preBatchRunner.Execute__c = true;

    Test.startTest();
      update preBatchRunner;
    Test.stopTest();

    Batch_Runner__c resultBatchRunner = [SELECT Id, Execute__c, Scope__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];
    Task resultTask = [SELECT Id, ActivityDate, WhatId, Status FROM Task WHERE WhatId = :resultBatchRunner.Id LIMIT 1];

    System.assertEquals(false, resultBatchRunner.Execute__c);
    System.assertEquals(null, resultBatchRunner.Scope__c);
    System.assertNotEquals(null, resultBatchRunner.Last_Executed_Date__c);
    System.assertEquals('Test BatchRunner Updated', resultBatchRunner.Description__c);
    System.assertNotEquals(null, resultTask.Id);
  }

  @isTest
  private static void testWithQuery() {
    Batch_Runner__c preBatchRunner = [SELECT Id, Execute__c, Scope__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];
    preBatchRunner.Execute__c     = true;
    preBatchRunner.Description__c = 'Test BatchRunner with Query';
    preBatchRunner.Scope__c       = 1;
    preBatchRunner.Batch_Query__c = 'SELECT Id, Name, Scope__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Scope__c = 1 AND Category__c = \'Misc\'';

    Test.startTest();
      update preBatchRunner;
    Test.stopTest();

    Batch_Runner__c resultBatchRunner = [SELECT Id, Execute__c, Scope__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];

    System.assertEquals(false, resultBatchRunner.Execute__c);
    System.assertEquals(1, resultBatchRunner.Scope__c);
    System.assertNotEquals(null, resultBatchRunner.Last_Executed_Date__c);
    System.assertEquals('Test BatchRunner with Query Updated', resultBatchRunner.Description__c);
  }

  @isTest
  private static void testWithScope() {
    Batch_Runner__c preBatchRunner = [SELECT Id, Execute__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];
    preBatchRunner.Execute__c = true;
    preBatchRunner.Scope__c = 10;

    Test.startTest();
      update preBatchRunner;
    Test.stopTest();

    Batch_Runner__c resultBatchRunner = [SELECT Id, Execute__c, Scope__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];

    System.assertEquals(false, resultBatchRunner.Execute__c);
    System.assertEquals(10, resultBatchRunner.Scope__c);
    System.assertNotEquals(null, resultBatchRunner.Last_Executed_Date__c);
    System.assertEquals('Test BatchRunner Updated', resultBatchRunner.Description__c);
  }

  @isTest
  private static void testWithError() {
    Batch_Runner__c preBatchRunner = [SELECT Id, Execute__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatch' LIMIT 1];
    preBatchRunner.Name = 'BatchRunnerValidBatchNot';
    preBatchRunner.Execute__c = true;

    Test.startTest();
      update preBatchRunner;
    Test.stopTest();

    Batch_Runner__c resultBatchRunner = [SELECT Id, Execute__c, Description__c, Last_Executed_Date__c FROM Batch_Runner__c WHERE Name = 'BatchRunnerValidBatchNot' LIMIT 1];

    System.assertEquals(false, resultBatchRunner.Execute__c);
    System.assertEquals(null, resultBatchRunner.Last_Executed_Date__c);
    System.assertEquals('Test BatchRunner', resultBatchRunner.Description__c);
  }
}