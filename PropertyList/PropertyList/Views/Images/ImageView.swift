import Combine
import SwiftUI

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
