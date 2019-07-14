# Batch Runner Object Setup
## Let's create a new Object.

Start with the object and tab: Batch Runner
- Label: Batch Runner
- Plural: Batch Runners
- Object Name: Batch_Runner
- Description: Describes a batch and variables to run that batch with an option to execute the batch
- Record Name: Batch Name
- Check: Allow Activities, Track Field History, Launch New Custom Tab Wizard after saving this custom object

Tab Setup:
- Object: Batch Runner
- Tab Style: Factory
- Description: List of Batches that can be run declaratively.
- Apply one tab visibility to all profiles: Tab Hidden (this will set them all to Tab Hidden)
- Apply a different tab visibility for each profile: checked after setting above to Tab Hidden
- Find your Admin Profile and set it to Default On
- Choose which App you want the Tab to be displayed in

Now add the custom fields:
- Category
  - Type: Picklist
  - Field Label: "Category"
  - Field Name: "Category"
  - Picklist Values: "Misc" (Define the categories that your batches fall into.  Misc is a good one to start with)
  - Description: "Category that Batch fits under"
  - Help Text: "Set the Category for the Batch"
  - Required: Checked
- Description
  - Type: Text Area (Long)
  - Field Label: "Description"
  - Field Name: "Description"
  - Description: "Description of what the batch is going to do."
  - Help Text: "Give a description of what the batch will do and any information needed if the batch query is updated."
  - \# Visible Lines: 8
  - Length: 1000
- Execute
  - Type: Checkbox
  - Field Label: "Execute"
  - Field Name: "Execute" (This will result in an API Name of Execute__c)
  - Description: "Checking this box will cause the Batch to run when saved."
  - Help Text: "Check this to run this Batch after save."
  - Default Value: Unchecked
- Active
  - Type: Checkbox
  - Field Label: "Active"
  - Field Name: "IsActive" (This will result in an API Name of IsActive__c)
  - Description: "Sets if this Batch Runner is active.  Batch will not Execute if it is not Active."
  - Help Text: "Check this to allow this Batch Runner to be available for Execution."
  - Default Value: Checked
- Last Executed Date
  - Type: Date/Time
  - Field Label: "Last Executed Date"
  - Field Name: "Last_Executed_Date" (This will result in an API Name of Last_Executed_Date__c)
  - Description: "Date and time of last Execution of this Batch.  Auto populated when batch is Executed."
  - Help Text: "Auto populated when batch is Executed."
- Batch Query
  - Type: Text Area (Long)
  - Field Label: "Batch Query"
  - Field Name: "Batch_Query" (This will result in an API Name of Batch_Query__c)
  - Description: "Dynamic Query for batch if it needs it or needs to run with different parameters. You can use :variables if they are declared in the start method of the batch file."
  - Help Text: "No need to escape \'."
  - \# Visible Lines: 10
  - Length: 32,768 (You could make this smaller if you like...)
- Scope
  - Type: Number
  - Field Label: "Scope"
  - Field Name: "Scope" (This will result in an API Name of Scope__c)
  - Description: "Limits the number of records executed in each Batch. Default if this is not set is 200."
  - Help Text: "Only set this if you need to scale back the number of records that run in each batch."
  - Length: 3
  - Decimal Places: 0

Finally create a Validation Rule:
- No_Execute_unless_Is_Active_BR001
  - Rule Name: "No_Execute_unless_Is_Active_BR001"
  - Active: Checked
  - Description: "Checks to be sure Active is checked when Execute is checked."
  - Error Condition Formula: "IF(Execute__c, IF(IsActive__c, false, true), false)"
  - Error Message: "This can not be Executed unless Active is checked. (BR001)"
  - Error Location: Field checked and Active selected


