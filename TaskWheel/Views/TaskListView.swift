import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var color = ColorSettings()
    
    var body: some View {
        List {
            ForEach(taskViewModel.taskList) { task in
                NavigationLink(value: task) {
                    ListRowView(task: task, action: taskViewModel.toggleComplete)
                }
            }
            .listRowBackground(color.background)
        }
        .listStyle(.plain)
//        .navigationTitle(taskListTitle)
        .navigationTitle("hi")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.never)
        .navigationDestination(for: TaskModel.self) { task in
            UpdateView(task: task)
        }
    }
}


#Preview {
    TaskListView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}
