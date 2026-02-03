import SwiftUI

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
    PetItem(
        pet: Pet(
            id: 1,
            name: "Amos",
            description: "Description",
            imageUrl: "https://example.com/image.jpg"
        )
    )
}
