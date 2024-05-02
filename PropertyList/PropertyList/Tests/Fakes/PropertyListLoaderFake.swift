@testable import PropertyList

import Combine
import XCTest

final class PropertyListLoaderFake: PropertyListLoading {
    var propertyListItems: [PropertyListItem]?
    var error: Error?
    
    var propertyListPublisher: AnyPublisher<[PropertyListItem], Error> {
        guard propertyListItems != nil || error != nil else {
            XCTFail("Both propertyListItems and error are nil")
            return Empty<[PropertyListItem], Error>()
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
        
        return Empty<[PropertyListItem], Error>()
            .eraseToAnyPublisher()
    }
}
