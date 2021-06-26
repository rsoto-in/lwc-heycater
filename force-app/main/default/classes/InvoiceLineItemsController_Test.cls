/**
 * @name: InvoiceLineItemsController_Test
 * @description: Apex Test class for invoiceLineItem LWC Controller class
 * @class: InvoiceLineItemsController
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-25 - Initial version
 */
@isTest
private inherited sharing class InvoiceLineItemsController_Test {

	private static final String	PROFILE_NAME_TEST = 'Standard User';
	private static final String	PERMISSION_SET_NAME_TEST = 'SalesUser';

	private static final String INVOICE_DATA_TEST = 'TestInvoices';

	private static final String INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	private static final String INVOICE_FIELD_API_NAME = 'Invoice__c';
	private static final String DIFFERENT_NUM_ILIS_W_INVOICE_ID_MSG = 'The number of Invoice Line Items with Invoice Id retrieved is not correct';
	private static final String DIFFERENT_NUM_ILIS_WO_INVOICE_ID_MSG = 'The number of Invoice Line Items with Invoice Id retrieved is not correct. It has to be zero.';
	private static final String DIFFERENT_NUM_ILIS_W_NULL_INVOICE_ID_MSG = 'The number of Invoice Line Items with null Invoice Id retrieved is not correct. It has to be zero';


	private static final String SELECT_OPERATION = 'SELECT';
	private static final String COUNT_AGGREGATE_FUNCTION_OPERATION = 'COUNT()';
	private static final String FROM_TARGET = 'FROM';
	private static final String WHERE_FILTER = 'WHERE';
	private static final String EQUAL_FILTER = '=';
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
	 * v0.1 - 2021-06-25 - Initial version
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
	 * @name: getInvoiceLineItemsTestPositive
	 * @description: Test method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsTestPositive()
	{
		User						user;
		Id							invoiceId;
		List<Invoice_Line_Item__c>	itemsList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		for (Invoice_Line_Item__c item : [SELECT Invoice__c FROM Invoice_Line_Item__c WHERE Invoice__c != NULL LIMIT 1])
		{
			invoiceId = item.Invoice__c;	
		}
		itemsList = new List<Invoice_Line_Item__c>();
		Test.startTest();
		System.runAs(user)
		{
			itemsList.addAll(InvoiceLineItemsController.getInvoiceLineItems(invoiceId));
		}
		Test.stopTest();
		query = SELECT_OPERATION + ' ' + COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME + ' ';
		query += EQUAL_FILTER + ' ' + '\'' + invoiceId + '\'' + ' ';
		query += MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsList.size(), DIFFERENT_NUM_ILIS_W_INVOICE_ID_MSG);
	}

	/**
	 * @name: getInvoiceLineItemsTestNegative
	 * @description: Test method with negative outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsTestNegative()
	{
		User						user;
		Id							invoiceId;
		List<Invoice__c>			invoicesList;
		List<Invoice_Line_Item__c>	itemsList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		
		invoicesList = new List<Invoice__c>();
		invoicesList.addAll((List<Invoice__c>) Test.loadData(Invoice__c.sObjectType, INVOICE_DATA_TEST));
		for (Invoice__c invoice : invoicesList)
		{
			invoiceId = invoice.Id;
		}
		itemsList = new List<Invoice_Line_Item__c>();
		Test.startTest();
		System.runAs(user)
		{
			itemsList.addAll(InvoiceLineItemsController.getInvoiceLineItems(invoiceId));
		}
		Test.stopTest();
		query = SELECT_OPERATION + ' ' + COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME + ' ';
		query += EQUAL_FILTER + ' ' + '\'' + invoiceId + '\'' + ' ';
		query += MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsList.size(), DIFFERENT_NUM_ILIS_WO_INVOICE_ID_MSG);
	}

	/**
	 * @name: getInvoiceLineItemsTestNull
	 * @description: Test method with null outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsTestNull()
	{
		User						user;
		Id							invoiceId;
		List<Invoice_Line_Item__c>	itemsList;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		
		itemsList = new List<Invoice_Line_Item__c>();
		Test.startTest();
		System.runAs(user)
		{
			itemsList.addAll(InvoiceLineItemsController.getInvoiceLineItems(invoiceId));
		}
		Test.stopTest();
		System.assertEquals(0, itemsList.size(), DIFFERENT_NUM_ILIS_W_NULL_INVOICE_ID_MSG);
	}
}