/**
 * @name: InvoiceLineItemsController_Test
 * @description: Apex Test class for invoiceLineItem LWC Controller class
 * @class: InvoiceLineItemsController
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-25 - Initial version
 * v0.2 - 2021-06-27 - Minor changes
 */
@IsTest
private with sharing class InvoiceLineItemsController_Test {

	private static final String DIFFERENT_NUM_ILIS_W_INVOICE_ID_MSG = 'The number of Invoice Line Items with Invoice Id retrieved is not correct';
	private static final String DIFFERENT_NUM_ILIS_WO_INVOICE_ID_MSG = 'The number of Invoice Line Items with Invoice Id retrieved is not correct. It has to be zero.';
	private static final String DIFFERENT_NUM_ILIS_W_NULL_INVOICE_ID_MSG = 'The number of Invoice Line Items with null Invoice Id retrieved is not correct. It has to be zero';

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
		User user = TestDataFactory.createUser(TestUtils.PROFILE_NAME_TEST);
		if (user != null)
		{
			TestDataFactory.assignPermissionSet(TestUtils.PERMISSION_SET_NAME_TEST, user.Id);
		}
		System.runAs(user)
		{
			TestDataFactory.createInvoicesAndILIs(7);
		}
	}

	/**
	 * @name: getInvoiceLineItemsPositiveTest
	 * @description: Test getInvoiceLineItems method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsPositiveTest()
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
		query = TestUtils.SELECT_OPERATION + ' ' + TestUtils.COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME + ' ';
		query += TestUtils.EQUAL_FILTER + ' ' + '\'' + invoiceId + '\'' + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsList.size(), DIFFERENT_NUM_ILIS_W_INVOICE_ID_MSG);
	}

	/**
	 * @name: getInvoiceLineItemsNegativeTest
	 * @description: Test getInvoiceLineItems method with negative outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsNegativeTest()
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
		invoicesList.addAll((List<Invoice__c>) Test.loadData(Invoice__c.sObjectType, TestUtils.INVOICE_DATA_TEST));
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
		query = TestUtils.SELECT_OPERATION + ' ' + TestUtils.COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME + ' ';
		query += TestUtils.EQUAL_FILTER + ' ' + '\'' + invoiceId + '\'' + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsList.size(), DIFFERENT_NUM_ILIS_WO_INVOICE_ID_MSG);
	}

	/**
	 * @name: getInvoiceLineItemsNullTest
	 * @description: Test getInvoiceLineItems method with null outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-25 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsNullTest()
	{
		User						user;
		Id							invoiceId;
		List<Invoice_Line_Item__c>	itemsList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		
		Test.startTest();
		System.runAs(user)
		{
			itemsList = InvoiceLineItemsController.getInvoiceLineItems(invoiceId);
		}
		Test.stopTest();
		query = TestUtils.SELECT_OPERATION + ' ' + TestUtils.COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += TestUtils.FROM_TARGET + ' ' + TestUtils.INVOICE_LINE_ITEM_API_NAME + ' ';
		query += TestUtils.WHERE_FILTER + ' ' + TestUtils.INVOICE_FIELD_API_NAME + ' ' + TestUtils.NULL_FILTER + ' ';
		query += TestUtils.MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsList.size(), DIFFERENT_NUM_ILIS_W_NULL_INVOICE_ID_MSG);
	}

	/**
	 * @name: getInvoiceLineItemsInvalidIdTest
	 * @description: Test getInvoiceLineItems method with invalid Id
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-27 - Initial version
	 */
	@IsTest
	static void getInvoiceLineItemsInvalidIdTest()
	{
		User						user;
		Id							invoiceId;
		List<Invoice_Line_Item__c>	itemsList;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}
		
		for (Invoice_Line_Item__c item : [SELECT Id FROM Invoice_Line_Item__c LIMIT 1])
		{
			invoiceId = item.Id;
		}
		Test.startTest();
		System.runAs(user)
		{
			itemsList = InvoiceLineItemsController.getInvoiceLineItems(invoiceId);
		}
		Test.stopTest();
		System.assertEquals(0, itemsList.size(), DIFFERENT_NUM_ILIS_W_NULL_INVOICE_ID_MSG);
	}
}