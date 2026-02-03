import SwiftUI

struct MainContentView: View {
    @State private var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if let error = viewModel.error {
                    Text("Oh no! There was an error: \(error)")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .transition(.blurReplace.combined(with: .opacity))
                }
                
                PetList(pets: viewModel.pets)
            }
        }
        .animation(.default, value: viewModel.error)
        .refreshable {
            await viewModel.onRefresh()
        }
        .task {
            await viewModel.fetchPets()
        }
    }
}

#Preview {
    MainContentView()
}
