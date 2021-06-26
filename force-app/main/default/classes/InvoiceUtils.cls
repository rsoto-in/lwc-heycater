/**
 * @name: InvoiceUtils
 * @description: Apex Utils class for Invoice__c object
 * @test: InvoiceUtils_Test
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-22 - Initial version
 */
public with sharing class InvoiceUtils {

	/**
	 * @name: calculateAmountILIs
	 * @description: Method for calculating Amount_Invoice_Line_Items__c field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param:	invoiceIdsSet	Set<Id>						Set of Invoice Ids to calculate
	 * 			itemsList		List<Invoice_Line_Item__c>	List of Invoice Line Items with Invoices to calculate
	 * @return: List<Invoice__c>	List of Invoices after calculation
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@TestVisible
	private static List<Invoice__c> calculateAmountILIs(
		Set<Id> invoiceIdsSet, 
		List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice__c>					invoicesList;
		Map<Id, List<Invoice_Line_Item__c>>	itemsByInvoiceMap;
		List<Invoice_Line_Item__c>			innerItemsList;
		Double amount;

		itemsByInvoiceMap = InvoiceLineItemUtils.getItemsByInvoiceMap(invoiceIdsSet, itemsList);
		invoicesList = new List<Invoice__c>();
		for (Invoice__c invoice : [SELECT Id, Amount_Invoice_Line_Items__c FROM Invoice__c WHERE Id IN :invoiceIdsSet])
		{
			invoice.Amount_Invoice_Line_Items__c = 0;
			innerItemsList = itemsByInvoiceMap.get(invoice.Id);
			if (innerItemsList != null)
			{
				for (Invoice_Line_Item__c item : innerItemsList)
				{
					amount = item.Amount__c != null ? item.Amount__c : 0;
					invoice.Amount_Invoice_Line_Items__c += amount;
				}
			}
			invoicesList.add(invoice);
		}
		return invoicesList;
	}

	/**
	 * @name: getInvoiceIdsSet
	 * @description: Method for getting a set of Invoice Ids
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: itemsList	List<Invoice_Line_Item__c>		List of Invoice Line Items with Invoices to get
	 * @return: Set<Id>	Set of Invoice Ids
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	public static Set<Id> getInvoiceIdsSet(List<Invoice_Line_Item__c> itemsList)
	{
		Set<Id>				invoiceIdsSet;

		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
		}
		return invoiceIdsSet;
	}

	/**
	 * @name: updateAmountILIs
	 * @description: Method for updating Amount_Invoice_Line_Items__c field
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: 	invoiceIdsSet	Set<Id>						Set of Invoice Ids to calculate
	 * 			itemsList		List<Invoice_Line_Item__c>	List of Invoice Line Items to use for Invoice calculation
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 * v0.1 - 2021-06-23 - Receive a set of Invoice Ids to be updated
	 */
	public static void updateAmountILIs(Set<Id>	invoiceIdsSet, List<Invoice_Line_Item__c> itemsList)
	{
		List<Invoice__c>	invoicesList;

		invoicesList = new List<Invoice__c>();
		invoicesList.addAll(InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList));
		if (!invoicesList.isEmpty())
		{
			update invoicesList;
		}
	}
}