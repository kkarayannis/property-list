import Combine
import SwiftUI

import PageLoader

final class PropertyListPage: Page {
    private let viewModel: PropertyListViewModel
    
    init(viewModel: PropertyListViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        AnyView(PropertyListView(viewModel: viewModel))
    }
    
    var title: String {
        viewModel.title
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        viewModel.pageStatePublisher
    }
    
    var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
        .inline
    }
    
    func load() {
        viewModel.loadProperties()
    }
}
