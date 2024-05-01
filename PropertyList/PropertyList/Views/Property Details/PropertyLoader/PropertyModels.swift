import Foundation

// Assuming all properties will be present. Make optional as needed.
struct Property: Decodable, Equatable {
    let type: PropertyType
    let id: String
    let askingPrice: Int
    let municipality: String
    let area: String
    let daysSincePublish: Int
    let livingArea: Int
    let numberOfRooms: Int
    let streetAddress: String
    let image: URL
    let description: String
    let patio: String // Parse to Bool if needed
    
    enum PropertyType: String, Decodable {
        case highlighted = "HighlightedProperty"
    }
}
