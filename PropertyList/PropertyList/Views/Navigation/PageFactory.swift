import Foundation

import ImageLoader
import PageLoader

enum PageType: Hashable {
    case propertyList
    // In production we would probably pass an id here instead of a full URL.
    case propertyDetails(URL)
}

/// Responsible for creating pages.
protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let propertyListLoader: PropertyListLoading
    private let propertyLoader: PropertyLoading
    private let imageLoader: ImageLoading
    private let logger: Logging
    
    init(
        propertyListLoader: PropertyListLoading,
        propertyLoader: PropertyLoading,
        imageLoader: ImageLoading,
        logger: Logging
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
