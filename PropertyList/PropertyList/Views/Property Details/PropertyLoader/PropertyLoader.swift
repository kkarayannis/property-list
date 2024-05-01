import Combine
import Foundation

import Cache
import DataLoader

// Loads property details from the network
protocol PropertyLoading {
    func publisher(for propertyURL: URL) -> AnyPublisher<Property, Error>
}

enum PropertyLoaderError: Error {
    case invalidURL
    case networkError
}

final class PropertyLoader: PropertyLoading {
    private static let propertyCacheKeyPrefix = "property-"
    private let dataLoader: DataLoading
    private let cache: Caching
    private let logger: Logging
    
    init(dataLoader: DataLoading, cache: Caching, logger: Logging) {
        self.dataLoader = dataLoader
        self.cache = cache
        self.logger = logger
    }
    
    func publisher(for propertyURL: URL) -> AnyPublisher<Property, Error> {
        guard let url = Endpoint.url else {
            return Fail(error: PropertyLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.publisher(for: url)
            .mapError { [weak self] error in
                // Handle network error more granularly if needed here.
                self?.logger.log(error.localizedDescription, logLevel: .error)
                return PropertyLoaderError.networkError
            }
            .cache(PublisherCache(key: (Self.propertyCacheKeyPrefix + url.absoluteString) .base64, cache: cache))
            .tryMap {
                try JSONDecoder().decode(Property.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    enum Endpoint {
        private static let urlString = "https://pastebin.com/raw/uj6vtukE"
        
        static var url: URL? {
            URL(string: urlString)
        }
    }
}
