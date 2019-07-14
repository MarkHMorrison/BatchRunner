# Batch Runner
## A declarative way to run batches on command.

It's not Blade Runner but in a way we are dealing with replicants of a kind...

Empower your blade runners... err... admins to run down those batches all by themselves.
Seriously, this will allow admins to selectively run batches anytime they need or want to.
With great power comes great responsibility, but that's a different movie.

### Create New Object

First we need to set up a new object, Batch Runner, and all it's configuration pieces.
- Check out the [BatchRunnerObject](../master/BatchRunnerObject.md) file with details on that.

Once we have the Batch Runner object we should add the trigger and it’s handler class. We will also create the test classes that we need for good code coverage.

### Create New Files

Create them in this order from the src folder:
- Apex Classes:
  - BatchRunnerValidBatch
  - BatchRunnerValidBatchTest
  - BatchRunnerTriggerHandler
  - BatchRunnerTriggerHandlerTest
- Apex Trigger:
  - BatchRunnerTrigger

> ### Be sure to change the email address for the BatchRunnerTriggerHandler. Look for setToAddresses around line 75.

Run your apex tests to be sure everything is set up and configured right.

### Add New Batch Runners

Now we can start to add Batch Runners for the various batches that we want our Admins to run. Since I’m only certain of one batch that we all have, let’s use that one.  BatchRunnerValidBatch is the test batch that is part of the package so we can have good code coverage.

Navigate to the Batch Runners tab and click the New button. In the Batch Name field put “BatchRunnerValidBatch”.  You don’t need the file extension. Select “Misc” for the Category. 

You know we have to add a Description in the Description Field. Let’s use “This is just a test batch that updates the Description field.  You’ll see if you Execute it.”

We won’t add anything to the Batch Query, Scope or other fields. Click the Save button.

That was fun. Want to Execute it?  Me too. After you clicked Save it should have landed you on the BatchRunnerValidBatch Batch Runner page. Click so you can edit it.  Check the Execute checkbox and click the Save button.

Right off the bat you’ll see that the Last Executed Date is populated and the Execute checkbox is unchecked. Also, note that the Description probably didn’t change.

Go to Setup and Quick Search for Apex Jobs.  Click on the Apex Jobs link and you should see the Batch Apex Job Type that just run with BatchRunnerValidBatch as the Apex Class. It should also show Completed for Status.

Now refresh the BatchRunnerValidBatch Batch Runner page and you should see the updated Description.

Ready to add your own batches?  Excellent!

### Working with Batch Query
If your batches are set up with a batchQuery variable like the BatchRunnerValidBatch then you can set a dynamic SOQL string in the Batch Query field. This allows you to change up the records the batch runs against without updating the code. Pretty clever. 

You can also use bind expressions like :variable in the SOQL if they are declared in the start method of the batch class file. You can see an example of this in the test classes.







