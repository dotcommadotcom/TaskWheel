import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView() {
            ForEach(taskViewModel.getIncompleteTasks()) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task, action: taskViewModel.toggleComplete)
                }
            }
            
            ForEach(taskViewModel.getCompletedTasks()) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task, action: taskViewModel.toggleComplete)
                }
            }
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
