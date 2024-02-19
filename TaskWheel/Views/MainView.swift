import SwiftUI

struct MainView: View {
    @State private var path = NavigationPath()
    
    let taskListTitle = "Sample Task List"
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(TaskModel.examples) { task in
                    ListRowView(task: task)
                }
            }
            .toolbarBackground(Color.white, for: .navigationBar)
            .listStyle(.plain)
            .navigationTitle(taskListTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    MainView()
}
