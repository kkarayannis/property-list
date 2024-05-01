import Combine
import SwiftUI

import PageLoader

final class PropertyDetailsPage: Page {
    private let viewModel: PropertyDetailsViewModel
    
    init(viewModel: PropertyDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        AnyView(PropertyDetailsView(viewModel: viewModel))
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
        viewModel.loadProperty()
    }
}
