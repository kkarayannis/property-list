import Foundation

import Cache
import DataLoader
import ImageLoader

protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func provideCache() -> Caching
    func providePageFactory() -> PageFactory
}

final class ServiceProvider: ServiceProviding {
    private let logger = Logger()
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    private let cache = Cache(fileManager: FileManager.default)
    private lazy var imageLoader = ImageLoader(dataLoader: dataLoader, cache: cache)
    private lazy var pageFactory = PageFactoryImplementation(
        propertyListLoader: PropertyListLoader(dataLoader: dataLoader, cache: cache, logger: logger),
        imageLoader: imageLoader,
        logger: logger
    )
    
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    func provideCache() -> Caching {
        cache
    }
    
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
