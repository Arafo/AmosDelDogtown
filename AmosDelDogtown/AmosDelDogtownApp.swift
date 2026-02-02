import SwiftUI

@main
struct AmosDelDogtownApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.petService, PetService())
        }
    }
}
