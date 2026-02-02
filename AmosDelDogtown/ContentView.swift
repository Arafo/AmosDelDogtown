import SwiftUI

struct ContentView: View {
    var body: some View {
        PetList(
            pets: [
                "Amos",
                "Rex",
                "Buddy",
                "Max",
                "Bella",
                "Flar",
                "Lar",
                "Cat"
            ]
        )
    }
}

#Preview {
    ContentView()
}
