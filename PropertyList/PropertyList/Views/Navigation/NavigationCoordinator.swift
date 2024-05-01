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
                        .modifier(ThemedNavigationBar())
                })
                .modifier(ThemedNavigationBar())
        }
        .tint(.primary)
    }
}

private struct ThemedNavigationBar: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                colorScheme == .light ? Theme.navigationBarLightColor : Theme.navigationBarDarkColor,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
