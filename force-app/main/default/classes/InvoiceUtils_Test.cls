/**
 * @name: InvoiceUtils_Test
 * @description: Apex Test class for Invoice__c Utils class
 * @class: InvoiceUtils
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 */
@isTest
private inherited sharing class InvoiceUtils_Test {

	private static final String	PROFILE_NAME_TEST = 'Standard User';
	private static final String	PERMISSION_SET_NAME_TEST = 'SalesUser';

	private static final String INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	private static final String INVOICE_FIELD_API_NAME = 'Invoice__c';
	private static final String INVOICE_NOT_UPDATE_MSG = 'Invoice\'s Amount Invoice Line Items has not been updated';
	
	private static final String SELECT_OPERATION = 'SELECT';
	private static final String FROM_TARGET = 'FROM';
	private static final String WHERE_FILTER = 'WHERE';
	private static final String NOT_NULL_FILTER = '!= NULL';
	private static final String NULL_FILTER = '= NULL';
	private static final String MAX_QUERY_LIMIT = 'LIMIT 50000';

	/**
	 * @name: setup
	 * @description: Setup method for testing
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@TestSetup
	static void setup()
	{
		User user = TestDataFactory.createUser(PROFILE_NAME_TEST);
		if (user != null)
		{
			TestDataFactory.assignPermissionSet(PERMISSION_SET_NAME_TEST, user.Id);
		}
		System.runAs(user)
		{
			TestDataFactory.createInvoicesAndILIs(7);
		}
	}

	/**
	 * @name: calculateAmountILIsTestPositive
	 * @description: Method test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-22 - Initial version
	 */
	@IsTest
	static void calculateAmountILIsTestPositive()
	{
		User 								user;
		List<Invoice_Line_Item__c> 			itemsList;
		SObjectType 						itemType;
		Map<String, Schema.SObjectField>	itemFieldsMap;
		String								fields;
		String								query;
		Map<Id, Decimal> 					sumByInvoiceManualMap;
		Map<Id, Decimal> 					sumByInvoiceAutoMap;
		Decimal								sum;
		Set<Id>								invoiceIdsSet;
		List<Invoice__c>					invoicesList;
		Id									invoiceId;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		// Prepare SOQL query string with all Invoice Line Item fields 
		itemType = Schema.getGlobalDescribe().get(INVOICE_LINE_ITEM_API_NAME);
		itemFieldsMap = itemType.getDescribe().fields.getMap();
		fields = '';
		for (String field : itemFieldsMap.keySet())
		{
			fields += field + ',';
		}
		query = SELECT_OPERATION + ' ' + fields.removeEnd(',') + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME +  ' ' + NOT_NULL_FILTER + ' ';
		query += MAX_QUERY_LIMIT;

		// Clone Invoice Line Items with Invoice lookup field value
		// Calculate Invoice amounts for test assertion (manual)
		itemsList = new List<Invoice_Line_Item__c>();
		sumByInvoiceManualMap = new Map<Id, Decimal>();
		invoiceIdsSet = new Set<Id>();
		for (Invoice_Line_Item__c item : Database.query(query))
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
			item.Amount__c += 10;
			itemsList.add(item.clone(false, true, false, false));
		}
		for (Invoice_Line_Item__c item : itemsList)
		{
			invoiceIdsSet.add(item.Invoice__c);
			if (!sumByInvoiceManualMap.isEmpty() && sumByInvoiceManualMap.containsKey(item.Invoice__c))
			{
				sum = sumByInvoiceManualMap.get(item.Invoice__c) + item.Amount__c;
				sumByInvoiceManualMap.put(item.Invoice__c, sum);
			}
			else
			{
				sumByInvoiceManualMap.put(item.Invoice__c, item.Amount__c);
			}
		}
		invoicesList = new List<Invoice__c>();
		Test.startTest();
		System.runAs(user)
		{
			invoicesList.addAll(InvoiceUtils.calculateAmountILIs(invoiceIdsSet, itemsList));
		}
		Test.stopTest();
		// Get Invoice amount calculations for test assertion (auto)
		sumByInvoiceAutoMap = new Map<Id, Decimal>();
		for (Invoice__c invoice : invoicesList)
		{
			sumByInvoiceAutoMap.put(invoice.Id, invoice.Amount_Invoice_Line_Items__c);
		}
		for (Id id : sumByInvoiceManualMap.keySet())
		{
			if (sumByInvoiceAutoMap.containsKey(id))
			{
				invoiceId = id;
				break;
			}
		}
		System.assertEquals(sumByInvoiceManualMap.get(invoiceId), sumByInvoiceAutoMap.get(invoiceId), INVOICE_NOT_UPDATE_MSG);
	}
}