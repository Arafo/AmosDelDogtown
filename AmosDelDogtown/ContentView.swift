import SwiftUI

struct ContentView: View {
    var body: some View {
        let pets = (1...100).map {
            "Pet clone \($0)"
        }
        
        PetList(pets: pets)
    }
}

#Preview {
    ContentView()
}
