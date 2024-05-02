import Combine
import Foundation

import Cache
import DataLoader

// Loads property list items from the network
protocol PropertyListLoading {
    var propertyListPublisher: AnyPublisher<[PropertyListItem], Error> { get }
}

enum PropertyListLoaderError: Error {
    case invalidURL
    case networkError
}

final class PropertyListLoader: PropertyListLoading {
    private static let propertyListCacheKey = "property-list"
    private let dataLoader: DataLoading
    private let cache: Caching
    private let logger: Logging
    
    init(dataLoader: DataLoading, cache: Caching, logger: Logging) {
        self.dataLoader = dataLoader
        self.cache = cache
        self.logger = logger
    }
    
    var propertyListPublisher: AnyPublisher<[PropertyListItem], Error> {
        guard let url = Endpoint.url else {
            return Fail(error: PropertyListLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.publisher(for: url)
            .mapError { [weak self] error in
                // Handle network error more granularly if needed here.
                self?.logger.log(error.localizedDescription, logLevel: .error)
                return PropertyListLoaderError.networkError
            }
            .cache(PublisherCache(key: Self.propertyListCacheKey.base64, cache: cache))
            .tryMap {
                try JSONDecoder().decode(PropertyListResponse.self, from: $0).items
            }
            .eraseToAnyPublisher()
    }
}

private enum Endpoint {
    private static let urlString = "https://pastebin.com/raw/nH5NinBi"
    
    static var url: URL? {
        URL(string: urlString)
    }
}
