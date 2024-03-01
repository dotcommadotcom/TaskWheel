import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView() {
            ForEach(taskViewModel.getCurrentTasks()) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task, action: taskViewModel.toggleCompleteTask)
                }
            }
            
            if taskViewModel.currentTaskList.isDoneVisible {
                ForEach(taskViewModel.getCurrentCompletedTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task, action: taskViewModel.toggleCompleteTask)
                    }
                }
            }
        }
    }
}

#Preview {
    return ListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
