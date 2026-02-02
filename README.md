# Step 2: Displaying Remote Images with AsyncImage

Learn how to load and display images from a URL using SwiftUI's built-in `AsyncImage`.

### 1. No External Dependencies Needed
SwiftUI includes `AsyncImage` out of the box, so no additional dependencies are required.

### 2. Update State to hold Pet objects
To access the image URL, we must store the full data objects in our state instead of just a list of names.

In `ContentView.swift`:
```swift
struct ContentView: View {
    // Define the state as an array of Pet objects
    @State private var pets: [Pet] = []
    
    var body: some View {
        // ...
    }
    .task {
        let petResponse = await petService.getPets()
        // Update the state with the full objects from the API
        pets = petResponse.result
    }
}
```

### 3. Display the Image using AsyncImage
The `AsyncImage` view handles the complexity of downloading, caching, and rendering remote images.

In `ContentView.swift`:
```swift
struct PetItem: View {
    let pet: Pet
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "https://" + pet.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .clipped() // Crops the image to fill the square area
            
            // Add a background to the text for better contrast
            Text(pet.name)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.5))
        }
        .frame(width: 150, height: 150)
    }
}
```

### 4. Add a NavigationStack with Title
`NavigationStack` is usded for navigation and displaying a title bar.
We use it with a `.navigationTitle`, but it also supports toolbar items, search, and more.

```swift
NavigationStack {
    // Your content here
}
.navigationTitle("Amos Del Dogtown")
```