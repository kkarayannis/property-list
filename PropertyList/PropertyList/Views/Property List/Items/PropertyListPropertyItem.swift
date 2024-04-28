import Foundation

import ImageLoader

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

final class PropertyListPropertyViewModel {
    let propertyItem: PropertyListPropertyItem
    let imageLoader: ImageLoading
    
    init(propertyItem: PropertyListPropertyItem, imageLoader: ImageLoading) {
        self.propertyItem = propertyItem
        self.imageLoader = imageLoader
    }
    
    var imageViewModel: ImageViewModel {
        ImageViewModel(url: propertyItem.image, imageLoader: imageLoader)
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
