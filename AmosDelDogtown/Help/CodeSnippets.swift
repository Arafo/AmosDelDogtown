import SwiftUI

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
                .clipped() // Crops the image to fill the square area
            }
            
            // Add a background to the text for better contrast
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

#Preview {
    PetList(pets: [
        Pet(id: 1, name: "Amos", description: "Description", imageUrl: "https://example.com/image.jpg"),
        Pet(id: 2, name: "Rex", description: "Description", imageUrl: "https://example.com/image.jpg"),
        Pet(id: 3, name: "Buddy", description: "Description", imageUrl: "https://example.com/image.jpg")
    ])
}
