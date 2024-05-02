@testable import PropertyList

import Combine
import XCTest

final class PropertyListLoaderFake: PropertyListLoader {
    var propertyListItems: [any PropertyListItem]?
    var error: Error?
    
    var propertyListPublisher: AnyPublisher<[any PropertyListItem], Error> {
        guard propertyListItems != nil || error != nil else {
            XCTFail("Both propertyListItems and error are nil")
            return Empty<[any PropertyListItem], Error>()
                .eraseToAnyPublisher()
        }
        
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let propertyListItems {
            return Just(propertyListItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<[any PropertyListItem], Error>()
            .eraseToAnyPublisher()
    }
}
