import SwiftUI

struct PetList: View {
    let pets: [String]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(pets, id: \.self) { pet in
                    PetItem(name: pet)
                }
            }
        }
    }
}

struct PetItem: View {
    let name: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
            
            Text(name)
                .padding(24)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
    }
}

#Preview {
    PetList(pets: ["Amos", "Rex", "Buddy"])
}
