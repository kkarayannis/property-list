import SwiftUI

@main
struct PropertyListApp: App {
    private let serviceProvider = ServiceProviderImplementation()
    
    var body: some Scene {
        WindowGroup {
            NavigationCoordinator(rootPageType: .propertyList, pageFactory: serviceProvider.providePageFactory())
        }
    }
}
