import Foundation

@Observable
class ContentViewModel {
    private let petRepository: PetRepositoryProtocol
    
    var pets: [Pet] = []
    var isLoading: Bool = false
    var error: String? = nil
    
    init(petRepository: PetRepositoryProtocol = PetRepository()) {
        self.petRepository = petRepository
    }
    
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
