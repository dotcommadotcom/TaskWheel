import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var path = NavigationPath()
    
    let colorBackground: Color = Color.seasaltJet
    
    let taskListTitle = "Sample Task List"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(taskViewModel.taskList) { task in
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
        .environmentObject(TaskViewModel(TaskModel.examples))
}

#Preview("dark") {
    MainView()
        .preferredColorScheme(.dark)
        .environmentObject(TaskViewModel(TaskModel.examples))
}
