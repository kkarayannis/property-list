import Combine
import Foundation

import ImageLoader
import PageLoader

final class PropertyDetailsViewModel {
    let url: URL
    
    // Dependencies
    private let propertyLoader: PropertyLoader
    private let logger: Logger
    let imageLoader: ImageLoader
    
    // State
    @Published private var propertyResult: Result<PropertyDetails, Error>?
    private var cancellable: AnyCancellable?
    
    var title: String {
        switch propertyResult {
        case .success(let property):
            property.streetAddress
        case .failure, nil:
            ""
        }
    }
    
    init(
        url: URL,
        propertyLoader: PropertyLoader,
        logger: Logger,
        imageLoader: ImageLoader
    ) {
        self.url = url
        self.propertyLoader = propertyLoader
        self.logger = logger
        self.imageLoader = imageLoader
    }
    
    lazy var propertyPublisher: AnyPublisher<PropertyDetails, Never> = $propertyResult
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
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $propertyResult
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
    
    func loadProperty() {
        cancellable = propertyLoader.publisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    self?.logger.log(failure.localizedDescription, logLevel: .error)
                    self?.propertyResult = .failure(failure)
                }
            }, receiveValue: { [weak self] property in
                self?.propertyResult = .success(property)
            })
    }
}
