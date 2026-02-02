# URLSession Implementation with async/await

Follow these steps to implement networking in iOS using URLSession and Swift's modern concurrency.

### 1. Dependencies Needed
iOS has built-in networking support with URLSession.

No dependencies required for basic networking!

### 2. Add Network Permission (if needed for local development)
In `Info.plist` (only if connecting to non-HTTPS endpoints):
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

For our API (https://www.zaragoza.es), HTTPS is already used, so no changes needed!

### 3. Define Data Models
The API returns data in JSON format. We'll create Swift structs that conform to `Codable` protocol.
The JSON will be automatically converted to these structs by `JSONDecoder`.

Create `Data/Pet.swift`:
```swift
struct PetResponse: Codable {
    let result: [Pet]
}

struct Pet: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case description = "observations"
        case imageUrl = "foto"
    }
}
```

### 4. Create API Service
This actor handles network requests using async/await. Using `actor` ensures thread-safety for our network service.

Create `Data/PetService.swift`:
```swift
actor PetService {
    private let baseURL = "https://www.zaragoza.es/sede/servicio/"
    
    func getPets() async throws -> PetResponse {
        guard let url = URL(string: baseURL + "mascotas") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(PetResponse.self, from: data)
    }
}
```

### 5. Setup Environment for Dependency Injection
This is how to provide our PetService throughout the app using SwiftUI's Environment.
We create an environment key so we can access the service in any view.

Create `Data/PetServiceKey.swift`:
```swift
import SwiftUI

private struct PetServiceKey: EnvironmentKey {
    static let defaultValue: PetService = PetService()
}

extension EnvironmentValues {
    var petService: PetService {
        get { self[PetServiceKey.self] }
        set { self[PetServiceKey.self] = newValue }
    }
}
```

Inject the service at app level in `AmosDelDogtownApp.swift`:
```swift
@main
struct AmosDelDogtownApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.petService, PetService())
        }
    }
}
```

### 6. Add changes in ContentView
Access the API service from the environment. We'll use it to call the api.
```swift
@Environment(\.petService) private var petApiService
```

Create a new state that will store the pet names we receive from the api request.
```swift
@State private var pets: [String] = []
```

Use our state in PetList
```swift
PetList(pets: pets)
```

Let's get real, call the api:
```swift
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
```