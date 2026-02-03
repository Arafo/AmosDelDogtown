# Adding Pull-to-Refresh and Error Handling


### 1. Update the ViewModel with onRefresh
Add an `onRefresh` method that can be called when the user pulls to refresh.
We add a small delay to ensure the refresh indicator is visible.

In `ContentViewModel.swift`, add:
```swift
@MainActor
func onRefresh() async {
    try? await Task.sleep(for: .seconds(1))
    await fetchPets()
}
```

### 2. Simplify ContentView
ContentView now just wraps `MainContentView` inside a `NavigationStack`.

```swift
struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            MainContentView()
                .navigationTitle("Amos Del Dogtown")
        }
    }
}
```

### 3. Create MainContentView with Error Banner and Pull-to-Refresh
The `MainContentView` owns the ViewModel and handles displaying errors and refresh capability.
- `.refreshable` provides native pull-to-refresh
- Error banner animates in/out using `.transition` and `.animation`

```swift
struct MainContentView: View {
    @State private var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if let error = viewModel.error {
                    Text("Oh no! There was an error: \(error)")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .transition(.blurReplace.combined(with: .opacity))
                }
                
                PetList(pets: viewModel.pets)
            }
        }
        .animation(.default, value: viewModel.error)
        .refreshable {
            await viewModel.onRefresh()
        }
        .task {
            await viewModel.fetchPets()
        }
    }
}
```
