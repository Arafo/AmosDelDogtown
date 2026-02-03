# Adding good architecture principles

Learn how to structure your SwiftUI app with proper separation of concerns using ViewModels, Repositories, and Protocols for testability.

### 1. No External Dependencies Needed
SwiftUI includes the `@Observable` macro out of the box for creating ViewModels, so no additional packages are required.

### 2. Project Structure
Organize your code into logical folders:
```
AmosDelDogtown/
├── Data/
│   ├── Models/
│   │   └── Pet.swift
│   ├── Repositories/
│   │   └── PetRepository.swift
│   └── Services/
│       └── PetService.swift
└── UI/
    ├── View/
    │   ├── ContentView.swift
    │   ├── PetListView.swift
    │   └── PetItemView.swift
    └── ViewModel/
        └── ContentViewModel.swift
```

### 3. Add Protocols for Testability
Protocols allow us to inject mock implementations for testing.

Update `PetService.swift` to add a protocol:
```swift
import Foundation

protocol PetServiceProtocol: Sendable {
    func getPets() async throws -> PetResponse
}

actor PetService: PetServiceProtocol {
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

### 4. Add Repository with Protocol
Repositories are in charge of communicating with network or databases.
The ViewModel requests information from the repo, and the repo is in charge of getting it from where it considers most appropriate.
E.g., It might get it from a database first, and then trigger a request in the background to get fresh data.

Create `PetRepository.swift`:
```swift
import Foundation

protocol PetRepositoryProtocol: Sendable {
    func getPets() async throws -> [Pet]
}

final class PetRepository: PetRepositoryProtocol {
    private let petService: PetServiceProtocol
    
    init(petService: PetServiceProtocol = PetService()) {
        self.petService = petService
    }
    
    func getPets() async throws -> [Pet] {
        return try await petService.getPets().result
    }
}
```

### 5. Create the ViewModel
The ViewModel will have an instance to the repository and exposes data to the UI through `@Observable`.
`@Observable` automatically tracks changes and updates the UI when properties change.

Create `ContentViewModel.swift`:
```swift
import Foundation

@Observable
class ContentViewModel {
    private let petRepository: PetRepositoryProtocol
    
    // The UI state properties that the view will observe
    var pets: [Pet] = []
    var isLoading: Bool = false
    var error: String? = nil
    
    init(petRepository: PetRepositoryProtocol = PetRepository()) {
        self.petRepository = petRepository
    }
    
    // Call this when the view appears
    @MainActor
    func fetchPets() async {
        // Post to the UI that we are loading
        isLoading = true
        error = nil
        
        do {
            // Call the repository
            pets = try await petRepository.getPets()
            isLoading = false
        } catch {
            // Post to the UI the error
            isLoading = false
            self.error = error.localizedDescription
        }
    }
}
```

### 6. Update ContentView to use the ViewModel
```swift
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
```

### 7. Create Reusable UI Components

**PetListView.swift** - A grid that displays pet items:
```swift
struct PetList: View {
    let pets: [Pet]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(pets) { pet in
                    PetItem(pet: pet)
                }
            }
        }
    }
}
```

**PetItemView.swift** - Individual pet card with image:
```swift
struct PetItem: View {
    let pet: Pet
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let imageUrl = pet.imageUrl {
                AsyncImage(url: URL(string: "https:" + imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .clipped()
            }
            
            Text(pet.name)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
        }
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
```
