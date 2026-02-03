import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            PetList(pets: viewModel.pets)
                .navigationTitle("Amos Del Dogtown")
        }
        .task {
            await viewModel.fetchPets()
        }
    }
}

#Preview {
    ContentView()
}
