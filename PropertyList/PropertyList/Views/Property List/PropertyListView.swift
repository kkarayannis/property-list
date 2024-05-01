import SwiftUI

struct PropertyListView: View {
    let viewModel: PropertyListViewModel
    
    @State private var items: [PropertyListItem] = []
    
    var body: some View {
        List(items) { item in
            switch item.type {
            case .property, .highlighted:
                // TODO: Confirm with backend/PM that we want to skip any entries that don't have all shown fields.
                if let propertyItem = item.propertyItem {
                    let viewModel = PropertyListPropertyViewModel(
                        propertyItem: propertyItem,
                        destinationURL: item.id == items.first?.id ? PropertyLoader.Endpoint.url : nil,
                        imageLoader: viewModel.imageLoader
                    )
                    if let destinationURL = viewModel.destinationURL {
                        PropertyListPropertyView(viewModel: viewModel)
                            .background {
                                NavigationLink(value: PageType.propertyDetails(destinationURL)) { EmptyView() }
                                    .opacity(0.0)
                            }
                    } else {
                        PropertyListPropertyView(viewModel: viewModel)
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