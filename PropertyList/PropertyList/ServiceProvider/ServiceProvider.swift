import Foundation

import Cache
import DataLoader

protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func provideCache() -> Caching
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    private let cache = Cache(fileManager: FileManager.default)
    func provideCache() -> Caching {
        cache
    }
}
