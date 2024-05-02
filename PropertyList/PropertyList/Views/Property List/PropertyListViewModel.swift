import Combine
import Foundation

import ImageLoader
import PageLoader

final class PropertyListViewModel {
    // Dependencies
    private let propertyListLoader: PropertyListLoader
    private let logger: Logger
    let imageLoader: ImageLoader
    
    // State
    @Published private var itemsResult: Result<[any PropertyListItem], Error>?
    private var cancellable: AnyCancellable?
    
    init(propertyListLoader: PropertyListLoader, imageLoader: ImageLoader, logger: Logger) {
        self.propertyListLoader = propertyListLoader
        self.imageLoader = imageLoader
        self.logger = logger
    }
    
    var title: String {
        String(localized: "Properties")
    }
    
    lazy var itemsPublisher: AnyPublisher<[any PropertyListItem], Never> = $itemsResult
        .compactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure, .none:
                return nil
            }
        }
        .removeDuplicates { lhs, rhs in
            let lhsIDs = lhs.map(\.id)
            let rhsIDs = rhs.map(\.id)
            
            return lhsIDs == rhsIDs
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $itemsResult
        .tryCompactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure(let error):
                throw error
            case .none:
                return nil
            }
        }
        .map { _ in .loaded } // If we receive any element, we consider the page loaded.
        .removeDuplicates()
        .replaceError(with: .error)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    func loadProperties() {
        cancellable = propertyListLoader.propertyListPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    self?.logger.log(failure.localizedDescription, logLevel: .error)
                    self?.itemsResult = .failure(failure)
                }
            }, receiveValue: { [weak self] items in
                self?.itemsResult = .success(items)
            })
    }
}
