import SwiftUI

struct PropertyListPropertyItem {
    let id: String
    let area: String
    let image: URL
    let municipality: String
    let askingPrice: Int
    let daysSincePublish: Int?
    let livingArea: Int
    let numberOfRooms: Int
    let streetAddress: String
    let monthlyFee: Int?
    let isHighlighted: Bool
}

struct PropertyListPropertyView: View {
    static let imageAspectRatio = 0.43042071
    static let imageHighlightedAspectRatio = 0.56808943
    let item: PropertyListPropertyItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            image
            
            Text(verbatim: item.streetAddress)
                .font(.title2)
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
    }
    
    @ViewBuilder 
    private var image: some View {
        Color.gray
            .aspectRatio(Self.imageAspectRatio, contentMode: .fill)
            .padding()
    }
    
    private var imageAspectRatio: Double {
        item.isHighlighted ? Self.imageHighlightedAspectRatio : Self.imageAspectRatio
    }
}

extension PropertyListItem {
    var propertyItem: PropertyListPropertyItem? {
        guard
            type != .area,
            let municipality,
            let askingPrice,
            let livingArea,
            let streetAddress,
            let numberOfRooms,
            let url = URL(string: image)
        else { return nil }
        
        return PropertyListPropertyItem(
            id: id,
            area: area,
            image: url,
            municipality: municipality,
            askingPrice: askingPrice,
            daysSincePublish: daysSincePublish,
            livingArea: livingArea,
            numberOfRooms: numberOfRooms,
            streetAddress: streetAddress,
            monthlyFee: monthlyFee,
            isHighlighted: type == .highlighted
        )
    }
}

#Preview {
    PropertyListPropertyView(item: PropertyListPropertyItem(
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
        isHighlighted: true))
}
