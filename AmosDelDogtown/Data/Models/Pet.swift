import Foundation

struct PetResponse: Codable {
    let result: [Pet]
}

struct Pet: Codable, Identifiable {
    let id: Int
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
