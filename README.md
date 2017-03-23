# UINames Swift Client

Swift client for [UINames.com](https://uinames.com).

Generate random people for your mock design.

You can generate people from...

* Random countries or select one
* Any gender or define one
* Set how many people are you asking for

## Usage

Here's a simple example .

```swift
UINamesClient.shared.people(amount: 430, extendedInformation: true, completionHandler: { (result: UINamesResult<[PersonExtended]>) -> (Void) in
    switch result
    {
        case let .success(people):
            for person in people
            {
                dump(person)
            }
        
        case let .error(message):
            print("> \(message)")
    }
})
```
