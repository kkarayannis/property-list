import SwiftUI
import ImageLoader

struct PropertyItemView: View {
    static let imageAspectRatio = 2.33
    static let imageHighlightedAspectRatio = 1.74
    let viewModel: PropertyItemViewModel
    
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
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            HStack {
                Text(verbatim: item.askingPrice.formatted(.number) + " SEK")
                
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

private extension PropertyItem {
    var isHighlighted: Bool {
        type == .highlighted
    }
}
