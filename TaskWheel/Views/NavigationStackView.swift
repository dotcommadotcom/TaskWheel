import SwiftUI

struct NavigationStackView: View {
    
    @State private var showSettings = false
    @State private var path = NavigationPath()
    
    var body: some View {
        VStack {
            NavigationStack(path: $path) {
                List {
                    Text("Root View")
                    NavigationLink("Go to A", value: "This is A")
                    NavigationLink("Go to 1", value: 1)
                    
                    Button(action: {
                        showSettings.toggle()
                    }, label: {
                        Text("Settings")
                    })
                    
                    Button {
                        path.append("Favorite")
                    } label: {
                        Text("Show favorite")
                    }
                    
                }
                .navigationTitle("Root view")
                .navigationDestination(for: String.self) { textValue in
                    DetailView(text: textValue, path: $path)
                }
                .navigationDestination(for: Int.self) { numberValue in
                    Text("Not detail view with \(numberValue)")
                }
                .navigationDestination(isPresented: $showSettings) {
                    Text("Settings")
                }
            }
            
            VStack {
                Text("Path")
                Text("Number of notroot view: \(path.count)")
                Button(action: {
                    path.removeLast()
                }, label: {
                    Text("Go Back")
                })
                Button {
                    path = NavigationPath()
                } label: {
                    Text("Go Home")
                }
                
            }
            
        }
    }
}

struct DetailView: View {
    let text: String
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("This is detail view")
            Text(text)
            
            Divider()
            
            NavigationLink("Link to 3", value: 3)
            NavigationLink("Link to C", value: "C")
        }
        .navigationTitle(text)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.left.circle")
                }

            }
        }
    }
}

#Preview {
    NavigationStackView()
}

#Preview("detail") {
    NavigationStack {
        DetailView(text: "this is text", path: .constant(NavigationPath()))
    }
}
