import Foundation

enum CacheError: Error {
    case cacheDirectoryMissing
    case cannotStoreData
}

/// Generic storage solution for caching data
public protocol Cache {
    func store(data: Data, key: String) async throws
    func data(for key: String) async throws -> Data?
}

public final class CacheImplementation: Cache {
    private var fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    private var cachesDirectoryURL: URL {
        get throws {
            guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                throw CacheError.cacheDirectoryMissing
            }
            
            return url
        }
    }
    
    public func store(data: Data, key: String) throws {
        let path = try cachesDirectoryURL.appending(path: key, directoryHint: .notDirectory).path()
        let success = fileManager.createFile(atPath: path, contents: data)
        
        guard success else {
            throw CacheError.cannotStoreData
        }
    }
    
    public func data(for key: String) throws -> Data? {
        let path = try cachesDirectoryURL.appending(path: key, directoryHint: .notDirectory).path()
        return fileManager.contents(atPath: path)
    }
}
