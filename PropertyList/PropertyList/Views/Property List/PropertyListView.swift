import SwiftUI

struct PropertyListView: View {
    let viewModel: PropertyListViewModel
    
    @State private var items: [any PropertyListItem] = []
    
    var body: some View {
        List(items, id: \.id) { item in
            switch item.type {
            case .property, .highlighted:
                // TODO: Confirm with backend/PM that we want to skip any entries that don't have all shown fields.
                if let propertyItem = item as? PropertyItem {
                    let viewModel = PropertyItemViewModel(
                        propertyItem: propertyItem,
                        destinationURL: item.id == items.first?.id ? PropertyLoaderImplementation.Endpoint.url : nil,
                        imageLoader: viewModel.imageLoader
                    )
                    if let destinationURL = viewModel.destinationURL {
                        PropertyItemView(viewModel: viewModel)
                            .background {
                                NavigationLink(value: PageType.propertyDetails(destinationURL)) { EmptyView() }
                                    .opacity(0.0)
                            }
                    } else {
                        PropertyItemView(viewModel: viewModel)
                    }
                }
            case .area:
                PropertyListAreaView()
            }
        }
        .listStyle(.plain)
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
        .refreshable {
            viewModel.loadProperties()
        }
    }
}
