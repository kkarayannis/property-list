import Foundation

import ImageLoader
import PageLoader

enum PageType: Hashable {
    case propertyList
}

/// Responsible for creating pages.
protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let propertyListLoader: PropertyListLoader
    private let imageLoader: ImageLoading
    private let logger: Logging
    
    init(propertyListLoader: PropertyListLoader, imageLoader: ImageLoading, logger: Logging) {
        self.propertyListLoader = propertyListLoader
        self.imageLoader = imageLoader
        self.logger = logger
    }
    
    func createPage(for type: PageType) -> Page {
        switch type {
        case .propertyList:
            propertyListPage
        }
    }
    
    private var propertyListPage: any Page {
        let viewModel = PropertyListViewModel(
            propertyListLoader: propertyListLoader,
            imageLoader: imageLoader,
            logger: logger
        )
        return PropertyListPage(viewModel: viewModel)
    }
}
