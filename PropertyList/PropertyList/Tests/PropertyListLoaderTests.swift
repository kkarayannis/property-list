import Combine
import XCTest
@testable import PropertyList

final class PropertyListLoaderTests: XCTestCase {
    
    // Unit under test
    var propertyListLoader: PropertyListLoader!
    
    // Dependencies
    var dataLoaderFake: DataLoaderFake!
    var cacheFake: CacheFake!
    var loggerFake: LoggerFake!
    
    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        try super.setUpWithError()
        dataLoaderFake = DataLoaderFake()
        cacheFake = CacheFake()
        loggerFake = LoggerFake()
        propertyListLoader = PropertyListLoader(dataLoader: dataLoaderFake, cache: cacheFake, logger: loggerFake)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        cancellable?.cancel()
    }

    func testLoadingPropertyList() throws {
        // Given the data loader has some data
        dataLoaderFake.data = try Helpers.propertyListTestData()
        
        // When we load the property list
        let expectation = expectation(description: "Loading property list")
        var expectedPropertyList: [PropertyListItem]?
        cancellable = propertyListLoader.propertyListPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { propertyList in
                expectedPropertyList = propertyList
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a property with some entries
        XCTAssertGreaterThan(expectedPropertyList?.count ?? 0, 0)
    }
    
    func testLoadingPropertyListWithDecodingError() throws {
        // Given the data loader has some bogus data
        dataLoaderFake.data = "this is not the property list you are looking for".data(using: .utf8)
        
        // When we load the property list
        let expectation = expectation(description: "Loading property list")
        var expectedError: Error?
        cancellable = propertyListLoader.propertyListPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                XCTFail("We were not expecting a valid object. Received: \(value)")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get an error
        XCTAssertNotNil(expectedError as? DecodingError)
    }
    
}
