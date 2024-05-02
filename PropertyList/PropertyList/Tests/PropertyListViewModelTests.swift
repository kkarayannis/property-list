@testable import PropertyList

import Combine
import Foundation
import XCTest

import PageLoader

final class PropertyListViewModelTests: XCTestCase {
    
    // Unit under test
    var viewModel: PropertyListViewModel!
    
    // Dependencies
    var propertyListLoaderFake: PropertyListLoaderFake!
    var imageLoaderFake: ImageLoaderFake!
    var loggerFake: LoggerFake!
    
    var cancellable: AnyCancellable?
    
    override func setUp() {
        super.setUp()
        
        propertyListLoaderFake = PropertyListLoaderFake()
        imageLoaderFake = ImageLoaderFake()
        loggerFake = LoggerFake()
        viewModel = PropertyListViewModel(
            propertyListLoader: propertyListLoaderFake,
            imageLoader: imageLoaderFake,
            logger: loggerFake
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable?.cancel()
    }
    
    func testLoadItems() throws {
        // Given the loader will return a property list
        propertyListLoaderFake.propertyListItems = try Helpers.responsePropertyList().items.compactMap(\.propertyListItem)
        
        // and that we subscribe to the itemsPublisher
        let expectation = expectation(description: "Loading items")
        var expectedItems: [any PropertyListItem]?
        cancellable = viewModel.itemsPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { items in
                expectedItems = items
                expectation.fulfill()
            })
        
        // When we load the items
        viewModel.loadProperties()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get some items
        XCTAssertGreaterThan(expectedItems?.count ?? 0, 0)
    }
    
    func testLoadItemsSetsTheStateToLoaded() throws {
        // Given the loader will return a property list
        propertyListLoaderFake.propertyListItems = try Helpers.responsePropertyList().items.compactMap(\.propertyListItem)
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the items
        viewModel.loadProperties()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .loaded)
    }
    
    func testLoadItemsSetsTheStateToError() throws {
        // Given the loader will produce an error
        propertyListLoaderFake.error = TestError.generic
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the properties
        viewModel.loadProperties()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .error)
    }
}
