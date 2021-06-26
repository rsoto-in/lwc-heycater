/**
 * @name: DebugUtils
 * @description: Apex Utils class for debugging
 * @test: N/A
 * @author: Richard Soto - richardsoto@outlook.com
 * @version: 0.1
 * @history
 * =======
 * v0.1 - 2021-06-26 - Initial version
 */
public with sharing class DebugUtils {

	private static final String EXCEPTION_MSG = 'The following exception has occurred: ';

	/**
	 * @name: printExceptionTypeAndMessage
	 * @description: Prints a debug message when an Exception has been thrown
	 * @author: Richard Soto - richardsoto@outlook.com
	 * @version: 0.1
	 * @param: e	Exception	A thrown exception
	 * @return: N/A
	 * @history
	 * =======
	 * v0.1 - 2021-06-26 - Method moved to InvoiceLineItemUtils
	 */
	public static void printExceptionTypeAndMessage(Exception e)
	{
		if (e != null)
		{
			System.debug(e.getTypeName());
			System.debug(e.getStackTraceString());
			System.debug(EXCEPTION_MSG + e.getMessage());
		}
	}
}