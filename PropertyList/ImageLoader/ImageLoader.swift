import Foundation
import Combine
import SwiftUI

import Cache
import DataLoader

/// Loads images from the network.
public protocol ImageLoading {
    func loadImage(for url: URL) -> AnyPublisher<UIImage, Error>
}

enum ImageLoaderError: Error {
    case imageDecodingError
    case networkError
}

public final class ImageLoader: ImageLoading {
    private let dataLoader: DataLoader
    private let cache: Caching
    
    public init(dataLoader: DataLoader, cache: Caching) {
        self.dataLoader = dataLoader
        self.cache = cache
    }
    
    public func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
        dataLoader.publisher(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                return ImageLoaderError.networkError
            }
            .cache(PublisherCache(key: url.absoluteString.base64, cache: cache))
            .tryMap {
                guard let image = UIImage(data: $0 ) else {
                    throw ImageLoaderError.imageDecodingError
                }
                return image
            }
            .eraseToAnyPublisher()
    }
    
    #if DEBUG
    private struct ImageLoaderFake: ImageLoading {
        enum PreviewError: Error {
            case unimplemented
        }
        func loadImage(for url: URL) -> AnyPublisher<UIImage, Error> {
            Fail(error: PreviewError.unimplemented)
                .eraseToAnyPublisher()
        }
    }
    public static var fake: ImageLoading { ImageLoaderFake() }
    #endif
}

private extension String {
    var base64: String {
        Data(utf8).base64EncodedString()
    }
}
