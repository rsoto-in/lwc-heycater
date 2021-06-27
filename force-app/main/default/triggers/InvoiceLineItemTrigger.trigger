/**
 * @name: InvoiceLineItemTrigger
 * @description: Trigger for Invoice_Line_Item__c object
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.2
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 * v0.2 - 2021-06-23 - Add After Delete functionality
 */
trigger InvoiceLineItemTrigger on Invoice_Line_Item__c (
	after insert,
	after update,
	after delete) {
	
	// Get trigger setup configuration
	TriggerSetup__mdt setup = TriggerSetup__mdt.getInstance('InvoiceLineItemTrigger');

	if (setup != null && setup.IsActive__c)
	{
		InvoiceLineItemTriggerHandler handler = new InvoiceLineItemTriggerHandler(
			Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

		if (Trigger.isInsert)
		{
			if (Trigger.isAfter)
			{
				handler.afterInsert();
			}
		}
		else if (Trigger.isUpdate)
		{
			if (Trigger.isAfter)
			{
				handler.afterUpdate();
			}
		}
		else if (Trigger.isDelete)
		{
			if (Trigger.isAfter)
			{
				handler.afterDelete();
			}
		}
	}
}