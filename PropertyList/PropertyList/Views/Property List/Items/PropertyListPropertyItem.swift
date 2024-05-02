import Foundation

import ImageLoader

final class PropertyListPropertyViewModel {
    let propertyItem: PropertyItem
    let destinationURL: URL?
    let imageLoader: ImageLoader
    
    init(propertyItem: PropertyItem, destinationURL: URL? = nil, imageLoader: ImageLoader) {
        self.propertyItem = propertyItem
        self.destinationURL = destinationURL
        self.imageLoader = imageLoader
    }
    
    var imageViewModel: ImageViewModel {
        ImageViewModel(url: propertyItem.imageURL, imageLoader: imageLoader)
    }
}
