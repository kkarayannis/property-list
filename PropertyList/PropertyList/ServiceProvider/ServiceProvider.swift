import Foundation

import Cache
import DataLoader

protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func provideCache() -> Caching
    func providePageFactory() -> PageFactory
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    private let cache = Cache(fileManager: FileManager.default)
    private let logger = Logger()
    private lazy var pageFactory = PageFactoryImplementation(
        propertyListLoader: PropertyListLoader(dataLoader: dataLoader, cache: cache, logger: logger), 
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
