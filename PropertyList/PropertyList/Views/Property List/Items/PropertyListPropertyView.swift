import SwiftUI
import ImageLoader

struct PropertyListPropertyView: View {
    static let imageAspectRatio = 2.3254716981
    static let imageHighlightedAspectRatio = 1.7383015598
    let viewModel: PropertyListPropertyViewModel
    
    var body: some View {
        let item = viewModel.propertyItem
        VStack(alignment: .leading, spacing: 5) {
            Color.clear
                .frame(maxWidth: .infinity)
                .aspectRatio(imageAspectRatio, contentMode: .fill)
                .border(Color.yellow, width: viewModel.propertyItem.isHighlighted ? 3 : 0)
                .background {
                    ImageView(viewModel: viewModel.imageViewModel)
                }
                .clipped()
                .padding(.bottom)
            
            Text(verbatim: item.streetAddress)
                .font(.title3)
                .fontWeight(.heavy)
            
            Text(verbatim: item.municipality)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            HStack {
                Text(verbatim: item.askingPrice.formatted(.number))
                
                Spacer()
                
                Text(verbatim: item.livingArea.formatted(.number) + " m\u{B2}")
                
                Spacer()
                
                Text(verbatim: String.localizedStringWithFormat("%d rooms", item.numberOfRooms))
            }
            .font(.subheadline)
            .fontWeight(.heavy)
        }
        .padding()
        .listRowSeparator(.hidden)
    }
    
    private var imageAspectRatio: Double {
        viewModel.propertyItem.isHighlighted ? Self.imageHighlightedAspectRatio : Self.imageAspectRatio
    }
}

#Preview {
    let item = PropertyListPropertyItem(
        id: "id",
        area: "100",
        image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg")!,
        municipality: "Stockholm",
        askingPrice: 1_000_000,
        daysSincePublish: nil,
        livingArea: 150,
        numberOfRooms: 5,
        streetAddress: "Mockvägen 42",
        monthlyFee: nil,
        isHighlighted: true)
    let viewModel = PropertyListPropertyViewModel(propertyItem: item, imageLoader: ImageLoader.fake)
    return PropertyListPropertyView(viewModel: viewModel)
}
