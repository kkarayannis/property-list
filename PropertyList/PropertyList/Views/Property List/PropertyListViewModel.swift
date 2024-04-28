import Combine
import Foundation

import PageLoader

final class PropertyListViewModel {
    // Dependencies
    private let propertyListLoader: PropertyListLoader
    private let logger: Logging
    
    // State
    @Published private var itemsResult: Result<[PropertyListItem], Error>?
    private var cancellable: AnyCancellable?
    
    init(propertyListLoader: PropertyListLoader, logger: Logging) {
        self.propertyListLoader = propertyListLoader
        self.logger = logger
    }
    
    var title: String {
        String(localized: "Properties")
    }
    
    lazy var itemsPublisher: AnyPublisher<[PropertyListItem], Never> = $itemsResult
        .removeDuplicates {
            if case .success(let lhs) = $0, case .success(let rhs) = $1 {
                return lhs == rhs
            }
            return false
        }
        .compactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure, .none:
                return nil
            }
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
        cancellable = propertyListLoader.publisher
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
