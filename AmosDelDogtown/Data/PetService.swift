import Foundation

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
