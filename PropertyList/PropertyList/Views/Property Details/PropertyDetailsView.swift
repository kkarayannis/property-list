import SwiftUI

struct PropertyDetailsView: View {
    let viewModel: PropertyDetailsViewModel
    
    @State private var property: Property?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                if let property {
                    ImageView(viewModel: ImageViewModel(url: property.image, imageLoader: viewModel.imageLoader))
                        .padding(.bottom)
                    
                    Text(verbatim: property.streetAddress)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(verbatim: property.municipality)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text(verbatim: property.askingPrice.formatted(.number))
                        .fontWeight(.bold)
                    
                    Text(verbatim: property.description)
                        .padding([.top, .bottom])
                    
                    livingAreaLine(property.livingArea.formatted(.number) + " m\u{B2}")
                    
                    roomsLine(property.numberOfRooms.formatted(.number))
                    
                    patioLine(property.patio)
                    
                    daysSincePublishLine(property.daysSincePublish.formatted(.number))
                }
            }
            .padding()
        }
        .onReceive(viewModel.propertyPublisher) {
            self.property = $0
        }
        .refreshable {
            viewModel.loadProperty()
        }
    }
    
    @ViewBuilder
    private func livingAreaLine(_ livingAreaString: String) -> some View {
        HStack(spacing: 0) {
            Text("Living Area")
                .fontWeight(.bold)
            Text(verbatim: ": ")
                .fontWeight(.bold)
            Text(verbatim: livingAreaString)
        }
    }
    
    @ViewBuilder
    private func roomsLine(_ roomsString: String) -> some View {
        HStack(spacing: 0) {
            Text("Number of rooms")
                .fontWeight(.bold)
            Text(verbatim: ": ")
                .fontWeight(.bold)
            Text(verbatim: roomsString)
        }
    }
    
    @ViewBuilder func patioLine(_ patioString: String) -> some View {
        HStack(spacing: 0) {
            Text("Patio")
                .fontWeight(.bold)
            Text(verbatim: ": ")
                .fontWeight(.bold)
            Text(verbatim: patioString)
        }
    }
    
    @ViewBuilder func daysSincePublishLine(_ daysSincePublishString: String) -> some View {
        HStack(spacing: 0) {
            Text("Days since publish")
                .fontWeight(.bold)
            Text(verbatim: ": ")
                .fontWeight(.bold)
            Text(verbatim: daysSincePublishString)
        }
    }
}
