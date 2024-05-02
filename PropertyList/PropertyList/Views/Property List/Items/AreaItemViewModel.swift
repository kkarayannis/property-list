import Foundation

import ImageLoader

struct AreaItemViewModel {
    let areaItem: AreaItem
    let imageLoader: ImageLoader
    
    init(areaItem: AreaItem, imageLoader: ImageLoader) {
        self.areaItem = areaItem
        self.imageLoader = imageLoader
    }
    
    var imageViewModel: ImageViewModel {
        ImageViewModel(url: areaItem.imageURL, imageLoader: imageLoader)
    }
}
