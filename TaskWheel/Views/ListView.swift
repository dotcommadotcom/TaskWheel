import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView() {
            ForEach(taskViewModel.taskList) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task, action: taskViewModel.toggleComplete)
                }
            }
        }
        .navigationDestination(for: TaskModel.self) { task in
            UpdateView(task: task)
        }
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    return ListView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}
