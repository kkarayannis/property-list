import SwiftUI

import PageLoader

/// The view that is responsible for Navigation.
struct NavigationCoordinator: View {
    let rootPageType: PageType
    let pageFactory: PageFactory
    
    var rootPage: any Page {
        pageFactory.createPage(for: rootPageType)
    }
        
    var body: some View {
        NavigationStack {
            PageLoader(page: rootPage)
                .navigationDestination(for: PageType.self, destination: { pageType in
                    let destinationPage = pageFactory.createPage(for: pageType)
                    PageLoader(page: destinationPage)
                    // TODO: make modifier
                    // TODO: make dynamic color (in Theme)
                        .toolbarBackground(Color(red: 0.89019608, green: 0.90980392, blue: 0.85098039), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                })
                .toolbarBackground(Color(red: 0.89019608, green: 0.90980392, blue: 0.85098039), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(.primary)
    }
}
