/**
 * @description Test class for BatchRunnerValidBatch class
 *              This is only to validate BatchRunnerTriggerHandlerTest
 * @author Mark H. Morrison
 * @date Tue Nov 6 2018
 */
@isTest
private class BatchRunnerValidBatchTest {

  @testSetup
  private static void setup() {
    Batch_Runner__c testBatchRunner = new Batch_Runner__c(
      Name           = 'BatchRunTest',
      Description__c = 'Test BatchRunner',
      Category__c    = 'Misc'
    );
    insert testBatchRunner;
    System.assertNotEquals(null, testBatchRunner.Id, 'Insert testBatchRunner failed');
  }

  @isTest
  private static void testBatchRunnerValidBatch() {

    Test.startTest();
      BatchRunnerValidBatch batchProcess = new BatchRunnerValidBatch();
      Id batchProcessId = Database.executeBatch(batchProcess);
    Test.stopTest();

    System.assertEquals('Test BatchRunner Updated', [SELECT Description__c FROM Batch_Runner__c].Description__c);
  }
}