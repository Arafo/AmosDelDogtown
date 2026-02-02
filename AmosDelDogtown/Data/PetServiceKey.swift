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
