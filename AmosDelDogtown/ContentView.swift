import SwiftUI

struct ContentView: View {
    @Environment(\.petService) private var petApiService
    @State private var pets: [String] = []
    
    var body: some View {
        PetList(pets: pets)
            .task {
                do {
                    // Execute the request call
                    let petResponse = try await petApiService.getPets()
                    
                    // From the response, for now we only want the names of the pets
                    let names = petResponse.result.map { pet in
                        pet.name
                    }
                    
                    // Store the new list of names in the state
                    pets = names
                } catch {
                    print("Error: \(error)")
                }
            }
    }
}

#Preview {
    ContentView()
}
