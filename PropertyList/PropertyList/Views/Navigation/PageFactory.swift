import Foundation

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
    private let logger: Logging
    
    init(propertyListLoader: PropertyListLoader, logger: Logging) {
        self.propertyListLoader = propertyListLoader
        self.logger = logger
    }
    
    func createPage(for type: PageType) -> Page {
        switch type {
        case .propertyList:
            propertyListPage
        }
    }
    
    private var propertyListPage: any Page {
        let viewModel = PropertyListViewModel(propertyListLoader: propertyListLoader, logger: logger)
        return PropertyListPage(viewModel: viewModel)
    }
}
