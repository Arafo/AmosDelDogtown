import SwiftUI

struct PetList: View {
    let pets: [Pet]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(pets) { pet in
                PetItem(pet: pet)
            }
        }
    }
}

#Preview {
    PetList(
        pets: [
            Pet(
                id: 1,
                name: "Amos",
                description: "Description",
                imageUrl: "https://example.com/image.jpg"
            ),
            Pet(
                id: 2,
                name: "Rex",
                description: "Description",
                imageUrl: "https://example.com/image.jpg"
            ),
            Pet(
                id: 3,
                name: "Buddy",
                description: "Description",
                imageUrl: "https://example.com/image.jpg"
            )
        ]
    )
}
