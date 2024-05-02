import SwiftUI

struct AreaItemView: View {
    static let imageAspectRatio = 2.33
    let viewModel: AreaItemViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Area")
                .font(.title2)
                .fontWeight(.bold)
            
            Color.clear
                .frame(maxWidth: .infinity)
                .aspectRatio(Self.imageAspectRatio, contentMode: .fill)
                .background {
                    ImageView(viewModel: viewModel.imageViewModel)
                }
                .clipped()
                .padding(.bottom)
            
            Text(verbatim: viewModel.areaItem.area)
                .font(.footnote)
                .fontWeight(.bold)
            
            Text(verbatim: String(localized: "Rating") + ": " + viewModel.areaItem.ratingFormatted)
                .font(.footnote)
            
            Text(verbatim: String(localized: "Average price")
                 + ": "
                 + viewModel.areaItem.averagePrice.formatted(.number)
                 + " m\u{B2}"
            )
            .font(.footnote)
        }
        .padding()
    }
}
