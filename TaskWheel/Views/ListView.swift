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
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return ListView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}
