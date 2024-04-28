import Combine
import SwiftUI

import ImageLoader

/// View that displays the images
struct ImageView: View {
    private let viewModel: ImageViewModel
    @State private var image: UIImage? = nil
    
    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
        
        image = nil
        viewModel.load()
    }
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray
            }
        }
        .onReceive(viewModel.$image) {
            image = $0
        }
    }
}

final class ImageViewModel {
    let url: URL?
    private let imageLoader: ImageLoading
    
    @Published var image: UIImage?
    private var cancellable: Cancellable?
    
    init(url: URL?, imageLoader: ImageLoading) {
        self.url = url
        self.imageLoader = imageLoader
    }
    
    func load() {
        guard let url else {
            return
        }
        cancellable = imageLoader.loadImage(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.image = $0
            })
    }
    
    #if DEBUG
    static var example: Self {
        self.init(
            url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg")!,
            imageLoader: ImageLoader.fake
        )
    }
    #endif
}
