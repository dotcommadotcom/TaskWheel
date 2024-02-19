import SwiftUI

struct MainView: View {
    @State private var path = NavigationPath()
    
    let colorBackground: Color = Color.seasaltJet
    let colorContrast: Color = Color.jetSeasalt
    let colorAccent: Color = Color.crayolaBlue
    
    let taskListTitle = "Sample Task List"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(TaskModel.examples) { task in
                        ListRowView(task: task)
                    }
                    .listRowBackground(colorBackground)
                }
                .listStyle(.plain)
                .navigationTitle(taskListTitle)
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.never)
                
                ButtonImageView(image: "plus", color: Color("crayolaBlue")) {
                    path.append("add view")
                }
                .padding(.trailing, 30)
                .navigationDestination(for: String.self) { _ in
                    AddView()
                }
            }
            .background(colorBackground)
        }
    }
}

#Preview {
    MainView()
}

#Preview("dark") {
    MainView()
        .preferredColorScheme(.dark)
}
