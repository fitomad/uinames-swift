 import UIKit
 import Foundation

 public class PersonExtended: Person
 {
 	///
 	public internal(set) var title: String!
 	///
 	public internal(set) var phone: String!
 	///
 	public internal(set) var age: Int!
 	///
 	public internal(set) var birthday: Date?
 	///
 	public internal(set) var photoURL: URL?
 	///
 	public internal(set) var email: Email?
 	///
 	public internal(set) var creditCard: CreditCard?

 	///
 	public var photo: UIImage?
 	{
        guard let photoURL = self.photoURL else
        {
            return nil
        }
        
        guard let data = try? Data(contentsOf: photoURL),
              let image = UIImage(data: data)
        else
        {
                return nil
        }

        return image
 	}

    /**

    */
    public init?(json dictionary: [String: Any])
    {
        guard let name = dictionary["name"] as? String,
              let surname = dictionary["surname"] as? String,
              let gender_value = dictionary["gender"] as? String,
              let gender = Gender(rawValue: gender_value),
              let country_value = dictionary["region"] as? String,
              let country = Country(rawValue: country_value.lowercased())
        else
        {
            return nil
        }
        
        super.init(named: name, surname: surname, gender: gender, from: country)


        if let title = dictionary["title"] as? String
        {
            self.title = title
        }

        if let phone = dictionary["phone"] as? String
        {
            self.phone = phone
        }

        if let age = dictionary["age"] as? Int
        {
            self.age = age
        }

        self.birthday = self.birthday(with: dictionary)
        self.creditCard = self.creditCard(with: dictionary)
        self.email = self.email(with: dictionary)
        self.photoURL = self.photoURL(with: dictionary)
    }

    /**

    */
    private func creditCard(with dictionary: [String: Any]) -> CreditCard?
    {
        if let credit_card = dictionary["credit_card"] as? [String: Any],
            let expiration = credit_card["expiration"] as? String,
            let number = credit_card["number"] as? String,
            let pin = credit_card["pin"] as? Int,
            let secure_code = credit_card["security"] as? Int
        {
            return CreditCard(numbered: number, expiresOn: expiration, pin: pin, securedBy: secure_code)
        }

        return nil
    }

    /**

    */
    private func email(with dictionary: [String: Any]) -> Email?
    {
        if let email = dictionary["email"] as? String,
           let password = dictionary["password"] as? String
        {
            return Email(email, password: password)
        }

        return nil
    }

    /**

    */
    private func photoURL(with dictionary: [String: Any]) -> URL?
    {
        if let photo_uri = dictionary["photo"] as? String,
           let photo_url = URL(string: photo_uri)
        {
            return photo_url
        }

        return nil
    }

    /**

    */
    private func birthday(with dictionary: [String: Any]) -> Date?
    {
        if let birthday = dictionary["birthday"] as? [String: Any],
           let raw = birthday["raw"] as? Double
        {
            return Date(timeIntervalSince1970: raw)
        }

        return nil
    }
 }
