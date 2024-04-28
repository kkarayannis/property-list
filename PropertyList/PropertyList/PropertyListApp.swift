import SwiftUI

@main
struct PropertyListApp: App {
    private let serviceProvider = ServiceProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationCoordinator(rootPageType: .propertyList, pageFactory: serviceProvider.providePageFactory())
        }
    }
}
