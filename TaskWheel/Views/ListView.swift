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

#Preview {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return ListView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}
