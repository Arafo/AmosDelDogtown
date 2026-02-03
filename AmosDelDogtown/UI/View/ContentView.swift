import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            MainContentView()
                .navigationTitle("Amos Del Dogtown")
        }
    }
}

#Preview {
    ContentView()
}
