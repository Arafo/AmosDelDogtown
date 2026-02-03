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
