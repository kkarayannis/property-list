import Foundation

import Cache
import DataLoader
import ImageLoader

protocol ServiceProvider {
    func provideDataLoader() -> DataLoader
    func provideCache() -> Cache
    func providePageFactory() -> PageFactory
}

final class ServiceProviderImplementation: ServiceProvider {
    private let logger = LoggerImplementation()
    private let dataLoader = DataLoaderImplementation(urlSession: URLSession.shared)
    private let cache = CacheImplementation(fileManager: FileManager.default)
    private lazy var imageLoader = ImageLoaderImplementation(dataLoader: dataLoader, cache: cache)
    private lazy var pageFactory = PageFactoryImplementation(
        propertyListLoader: PropertyListLoaderImplementation(dataLoader: dataLoader, cache: cache, logger: logger),
        propertyLoader: PropertyLoaderImplementation(dataLoader: dataLoader, cache: cache, logger: logger),
        imageLoader: imageLoader,
        logger: logger
    )
    
    func provideDataLoader() -> DataLoader {
        dataLoader
    }
    
    func provideCache() -> Cache {
        cache
    }
    
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
