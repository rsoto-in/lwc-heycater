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
private inherited sharing class InvoiceLineItemUtils_Test
{
	private static final String	PROFILE_NAME_TEST = 'Standard User';
	private static final String	PERMISSION_SET_NAME_TEST = 'SalesUser';

	private static final String INVOICE_LINE_ITEM_API_NAME = 'Invoice_Line_Item__c';
	private static final String INVOICE_FIELD_API_NAME = 'Invoice__c';
	private static final String DIFFERENT_NUM_ILIS_W_INVOICE_MSG = 'The number of Invoice Line Items with Invoice retrieved is not correct';
	
	private static final String SELECT_OPERATION = 'SELECT';
	private static final String COUNT_AGGREGATE_FUNCTION_OPERATION = 'COUNT()';
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
	 * @name: getILIsWithInvoiceTestPositive
	 * @description: Test method with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-23 - Initial version
	 */
	@IsTest
	static void getILIsWithInvoiceTestPositive()
	{
		User						user;
		List<Invoice_Line_Item__c>	itemsList;
		List<Invoice_Line_Item__c>	itemsWithInvoiceList;
		String						query;

		for (User testUser : [SELECT Id FROM User WHERE Username = :TestDataFactory.USERNAME_TEST LIMIT 1])
		{
			user = testUser;
		}

		itemsList = new List<Invoice_Line_Item__c>();
		for (Invoice_Line_Item__c item : [SELECT Id, Invoice__c FROM Invoice_Line_Item__c LIMIT 50000])
		{
			itemsList.add(item);
		}
		itemsWithInvoiceList = new List<Invoice_Line_Item__c>();
		Test.startTest();
		System.runAs(user)
		{
			itemsWithInvoiceList.addAll(InvoiceLineItemUtils.getILIsWithInvoice(itemsList));
		}
		Test.stopTest();
		query = SELECT_OPERATION + ' ';
		query += COUNT_AGGREGATE_FUNCTION_OPERATION + ' ';
		query += FROM_TARGET + ' ' + INVOICE_LINE_ITEM_API_NAME + ' ';
		query += WHERE_FILTER + ' ' + INVOICE_FIELD_API_NAME + ' ' + NOT_NULL_FILTER + ' ';
		query += MAX_QUERY_LIMIT;
		System.assertEquals(Database.countQuery(query), itemsWithInvoiceList.size(), DIFFERENT_NUM_ILIS_W_INVOICE_MSG);
	}
}
