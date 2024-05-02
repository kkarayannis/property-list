import Foundation

import ImageLoader
import PageLoader

enum PageType: Hashable {
    case propertyList
    case propertyDetails(URL)
}

/// Responsible for creating pages.
protocol PageFactory {
    /// Creates page for a certain type.
    /// - Parameter type: The page type that will be created.
    /// - Returns: A Page for a given type that will be used by PageLoader.
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let propertyListLoader: PropertyListLoader
    private let propertyLoader: PropertyLoader
    private let imageLoader: ImageLoader
    private let logger: Logger
    
    init(
        propertyListLoader: PropertyListLoader,
        propertyLoader: PropertyLoader,
        imageLoader: ImageLoader,
        logger: Logger
    ) {
        self.propertyListLoader = propertyListLoader
        self.propertyLoader = propertyLoader
        self.imageLoader = imageLoader
        self.logger = logger
    }
    
    func createPage(for type: PageType) -> Page {
        switch type {
        case .propertyList:
            createPropertyListPage()
        case let .propertyDetails(url):
            createPropertyPage(url: url)
        }
    }
    
    private func createPropertyListPage() -> any Page {
        let viewModel = PropertyListViewModel(
            propertyListLoader: propertyListLoader,
            imageLoader: imageLoader,
            logger: logger
        )
        return PropertyListPage(viewModel: viewModel)
    }
    
    private func createPropertyPage(url: URL) -> any Page {
        let viewModel = PropertyDetailsViewModel(
            url: url,
            propertyLoader: propertyLoader,
            logger: logger, 
            imageLoader: imageLoader
        )
        return PropertyDetailsPage(viewModel: viewModel)
    }
}
