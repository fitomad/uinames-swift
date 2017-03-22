 import Foundation

public struct CreditCard
{
	///
	public private(set) var number: String
	///
	public private(set) var expirationDateFormatted: String
	///
	public private(set) var pin: Int
	///
	public private(set) var secureCode: Int

	/**

	*/
	internal init(numbered number: String, expiresOn date: String, pin: Int, securedBy code: Int)
	{
		self.number = number
		self.expirationDateFormatted = date
		self.pin = pin
		self.secureCode = code
	}
}
