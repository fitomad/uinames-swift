 import Foundation

 public struct Email
 {
 	///
 	public private(set) var address: String
 	///
 	public private(set) var password: String

 	/**

 	*/
 	internal init(_ address: String, password: String)
 	{
 		self.address = address
 		self.password = password
 	}
 }
