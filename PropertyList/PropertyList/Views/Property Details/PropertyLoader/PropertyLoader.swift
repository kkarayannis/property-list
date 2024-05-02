import Combine
import Foundation

import Cache
import DataLoader

// Loads property details from the network
protocol PropertyLoader {
    func publisher(for propertyURL: URL) -> AnyPublisher<PropertyDetails, Error>
}

final class PropertyLoaderImplementation: PropertyLoader {
    private static let propertyCacheKeyPrefix = "property-"
    private let dataLoader: DataLoader
    private let cache: Cache
    private let logger: Logger
    
    init(dataLoader: DataLoader, cache: Cache, logger: Logger) {
        self.dataLoader = dataLoader
        self.cache = cache
        self.logger = logger
    }
    
    func publisher(for propertyURL: URL) -> AnyPublisher<PropertyDetails, Error> {
        guard let url = Endpoint.url else {
            return Fail(error: DataLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.publisher(for: url)
            .mapError { [weak self] error in
                // Handle network error more granularly if needed here.
                self?.logger.log(error.localizedDescription, logLevel: .error)
                return DataLoaderError.networkError
            }
            .cache(PublisherCacheImplementation(
                key: (Self.propertyCacheKeyPrefix + url.absoluteString).base64, cache: cache)
            )
            .tryMap {
                try JSONDecoder().decode(PropertyDetails.self, from: $0)
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
