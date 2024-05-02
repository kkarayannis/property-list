@testable import PropertyList

import Foundation

enum TestError: Error {
    case generic
    case dataError
}

final class Helpers {
    static func responseData() throws -> Data {
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: "properties", withExtension: "json") else {
            throw TestError.dataError
        }
        return try Data(contentsOf: url)
    }
    
    static func responsePropertyList() throws -> PropertyListResponse {
        let data = try responseData()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PropertyListResponse.self, from: data)
    }
}
