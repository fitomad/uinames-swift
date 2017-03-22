 import Foundation

 public class Person
 {
 	///
 	public private(set) var name: String
 	///
 	public private(set) var surname: String
 	///
 	public private(set) var gender: Gender
 	//
 	public private(set) var region: Country

 	/**

 	*/
 	internal init(named name: String, surname: String, gender: Gender, from region: Country)
 	{
 		self.name = name
 		self.surname = surname
 		self.gender = gender
 		self.region = region
 	}
 }
