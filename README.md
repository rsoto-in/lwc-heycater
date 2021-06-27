# heycater! LWC project

A heycater! project using Lightning Web Component (LWC) on Salesforce Platform.

## Table of contents

-   [Requirements](#requirements)
-   [Metadata](#metadata)
-   [Installation](#installation)

## Requirements

This project is based on two custom objects: Invoice and Invoice Line Item (ILI):

- Each ILI has a lookup relationship to an Invoice, and a currency field: Amount.
- Each Invoice has a currency field: Amount Invoice Line Items.

The project's tasks were the following:

- **Using a trigger**, make sure that **Amount Invoice Line Items** always contains the summary of **Amount** of all ILIs associated with the invoice. Please follow SF best practices when implementing this feature, and provide a well thought test class.
- Create a Lightning Component that shows a table of all ILIs associated with a specific invoice (the table should have two columns, for **Name** and for **Amount**). Please show above the table the **Name** and **Amount Invoice Line Items** of the corresponding invoice. The component should be opened from an action on the Invoice page. You can create either an Aura or a LWC component, but using LWC in your solution is preferred.

## Metadata

This project has the following Salesforce metadata:

- **ApexClass**
	- *DebugUtils*
	- *InvoiceLineItemTriggerHandler*
	- *InvoiceLineItemTriggerHandler_Test*
	- *InvoiceLineItemUtils*
	- *InvoiceLineItemUtils_Test*
	- *InvoiceLineItemsController*
	- *InvoiceLineItemsController_Test*
	- *InvoiceUtils*
	- *InvoiceUtils_Test*
	- *TestDataFactory*
	- *TestUtils*


- **ApexTestSuite**
	- *TestAssignment*


- **ApexTrigger**
	- *InvoiceLineItemTrigger*


- **ContentAsset**
	- *heycater_logo*


- **CustomApplication**
	- *Test_Assignment*


- **CustomMetadata**
	- *TriggerSetup.InvoiceLineItemTrigger*


- **CustomObject**
	- *Invoice_Line_Item__c*
	- *Invoice__c*
	- *TriggerSetup__mdt*


- **CustomTab**
	- *Invoice_Line_Item__c*
	- *Invoice__c*


- **FlexiPage**
	- *Test_Assignment_UtilityBar*


- **Layout**
	- *Invoice__c-Invoice Layout*
	- *Invoice_Line_Item__c-Invoice Line Item Layout*
	- *TriggerSetup__mdt-Trigger Setup Layout*


- **LightningComponentBundle**
	- *invoiceLineItems*


- **PermissionSet**
	- *TestAssignmentUser*


- **QuickAction**
	- *Invoice__c.InvoiceLineItems*


- **StaticResource**
	- *TestInvoiceLineItems*
	- *TestInvoices*

## Installation
**Installing the App using a Developer Edition Org or a Trailhead Playground**

Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org.
This includes non source-tracked orgs such as a [free Developer Edition Org](https://developer.salesforce.com/signup) or a [Trailhead Playground](https://trailhead.salesforce.com/).

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

1. Clone this repository:

    ```
    git clone https://github.com/rsoto-in/lwc-heycater
    cd lwc-heycater
    ```

1. Authorize your Trailhead Playground or Developer org and provide it with an alias (**alias** in the command below):

    ```
    sfdx auth:web:login -s -a alias
    ```

1. Run this command in a terminal to deploy the app.

    ```
    sfdx force:source:deploy -p force-app
    ```

1. Assign the `TestAssignmentUser` permission set to the default user.

    ```
    sfdx force:user:permset:assign -n TestAssignmentUser
    ```

1. If your org isn't already open, open it now:

    ```
    sfdx force:org:open -u alias
    ```

1. In App Launcher, select the **Test Assignment** app.
