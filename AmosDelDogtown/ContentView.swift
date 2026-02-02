import SwiftUI

struct ContentView: View {
    @Environment(\.petService) private var petApiService
    // Define the state as an array of Pet objects
    @State private var pets: [Pet] = []
    
    var body: some View {
        NavigationStack {
            PetList(pets: pets)
                .navigationTitle("Amos Del Dogtown")
        }
        .task {
            do {
                // Execute the request call
                let petResponse = try await petApiService.getPets()
                
                // Update the state with the full objects from the API
                pets = petResponse.result
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.petService, PetService())
}
