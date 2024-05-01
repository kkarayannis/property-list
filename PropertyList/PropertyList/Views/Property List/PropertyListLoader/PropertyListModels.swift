import Foundation

struct PropertyListResponse: Decodable {
    let items: [PropertyListItem]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct PropertyListItem: Decodable, Equatable, Identifiable {
    let type: ItemType
    let id: String
    let area: String
    let image: String
    
    let municipality: String?
    let askingPrice: Int?
    let daysSincePublish: Int?
    let livingArea: Int?
    let numberOfRooms: Int?
    let streetAddress: String?
    let monthlyFee: Int?
    
    let ratingFormatted: String?
    let averagePrice: Int?
    
    enum ItemType: String, Decodable {
        case highlighted = "HighlightedProperty"
        case property = "Property"
        case area = "Area"
    }
}
