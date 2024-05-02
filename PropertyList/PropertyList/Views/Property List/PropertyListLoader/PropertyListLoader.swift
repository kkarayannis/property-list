import Combine
import Foundation

import Cache
import DataLoader

// Loads property list items from the network
protocol PropertyListLoader {
    var propertyListPublisher: AnyPublisher<[any PropertyListItem], Error> { get }
}

final class PropertyListLoaderImplementation: PropertyListLoader {
    private static let propertyListCacheKey = "property-list"
    private let dataLoader: DataLoader
    private let cache: Cache
    private let logger: Logger
    
    init(dataLoader: DataLoader, cache: Cache, logger: Logger) {
        self.dataLoader = dataLoader
        self.cache = cache
        self.logger = logger
    }
    
    var propertyListPublisher: AnyPublisher<[any PropertyListItem], Error> {
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
            .cache(PublisherCacheImplementation(key: Self.propertyListCacheKey.base64, cache: cache))
            .tryMap {
                try JSONDecoder().decode(PropertyListResponse.self, from: $0).items.compactMap(\.propertyListItem)
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
