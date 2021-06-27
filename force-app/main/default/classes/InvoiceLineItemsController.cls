/**
 * @name: InvoiceLineItemsController
 * @description: Apex Controller class for invoiceLineItem LWC
 * @test: InvoiceLineItemsController_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-25 - Initial version
 */
public with sharing class InvoiceLineItemsController {

	/**
	 * @name: getInvoiceLineItems
	 * @description: Method for getting a list of Invoice Line Items related to an Invoice
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	invoiceId	Id	Invoice Identifier to look up for its related ILIs
	 * @return: List<Invoice_Line_Item__c>	List of Invoice Line Items related to an Invoice
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@AuraEnabled
	public static List<Invoice_Line_Item__c> getInvoiceLineItems(Id invoiceId)
	{
		List<Invoice_Line_Item__c> itemsList;

		itemsList = new List<Invoice_Line_Item__c>();
		try
		{
			for (Invoice_Line_Item__c item : [SELECT Id, Name, Amount__c FROM Invoice_Line_Item__c WHERE Invoice__c = :invoiceId LIMIT 50000])
			{
				itemsList.add(item);
			}
		}
		catch (Exception e)
		{
			DebugUtils.printExceptionTypeAndMessage(e);
		}
		return itemsList;
	}
}