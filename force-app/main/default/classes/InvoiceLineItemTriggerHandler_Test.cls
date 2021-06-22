/**
 * @name: InvoiceLineItemTriggerHandler_Test
 * @description: Apex Test class for Invoice_Line_Item__c Trigger handler
 * @class: InvoiceLineItemTriggerHandler
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-21 - Initial version
 */
@isTest
private inherited sharing class InvoiceLineItemTriggerHandler_Test {

	private static String PROFILE_NAME_TEST = 'Standard User';
	private static String PERMISSION_SET_API_NAME_TEST = 'SalesUser';

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
		User testUser;
		
		TestDataFactory.createInvoicesAndILIs(7);
		testUser = TestDataFactory.createUser(PROFILE_NAME_TEST);
		if (testUser != null)
		{
			TestDataFactory.assignPermissionSet(PERMISSION_SET_API_NAME_TEST, testUser.Id);
		}
	}

	/**
	 * @name: afterInsertTestPositive
	 * @description: After Insert test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@IsTest
	static void afterInsertTestPositive()
	{
		/*
		Test.startTest();
		System.runAs(contextuser){
			
		}
		Test.stopTest();
		*/
	}

	/**
	 * @name: afterUpdateTestPositive
	 * @description: After Update test with positive outcome
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: N/A
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-21 - Initial version
	 */
	@IsTest
	static void afterUpdateTestPositive()
	{
		/*
		Test.startTest();
		System.runAs(contextuser){
			
		}
		Test.stopTest();
		*/
	}
}