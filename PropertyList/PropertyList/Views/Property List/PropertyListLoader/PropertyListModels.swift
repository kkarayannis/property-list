import Foundation

enum PropertyListItemType: String, Decodable {
    case highlighted = "HighlightedProperty"
    case property = "Property"
    case area = "Area"
}

struct PropertyListResponse: Decodable {
    let items: [ResponseItem]
}

struct ResponseItem: Decodable {
    let type: PropertyListItemType
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
}

protocol PropertyListItem: Identifiable, Equatable {
    var type: PropertyListItemType { get }
    var id: String { get }
}

struct PropertyItem: PropertyListItem {
    let type: PropertyListItemType
    let id: String
    let area: String
    let imageURL: URL
    let municipality: String
    let askingPrice: Int
    let daysSincePublish: Int
    let livingArea: Int
    let numberOfRooms: Int
    let streetAddress: String
    let monthlyFee: Int?
}

struct AreaItem: PropertyListItem {
    let type: PropertyListItemType = .area
    let id: String
    let area: String
    let imageURL: URL
    let ratingFormatted: String
    let averagePrice: Int
}

extension ResponseItem {
    var propertyListItem: (any PropertyListItem)? {
        switch type {
        case .highlighted, .property:
            guard
                let imageURL = URL(string: image),
                let municipality,
                let askingPrice,
                let daysSincePublish,
                let livingArea,
                let numberOfRooms,
                let streetAddress
            else { return nil }
            return PropertyItem(
                type: type,
                id: id,
                area: area,
                imageURL: imageURL,
                municipality: municipality,
                askingPrice: askingPrice,
                daysSincePublish: daysSincePublish,
                livingArea: livingArea,
                numberOfRooms: numberOfRooms,
                streetAddress: streetAddress,
                monthlyFee: monthlyFee
            )
        case .area:
            guard
                let imageURL = URL(string: image),
                let ratingFormatted,
                let averagePrice
            else { return nil }
            return AreaItem(
                id: id,
                area: area,
                imageURL: imageURL,
                ratingFormatted: ratingFormatted,
                averagePrice: averagePrice
            )
        }
    }
}
