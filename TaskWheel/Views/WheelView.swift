import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskViewModel.getCurrentTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task, action: taskViewModel.toggleCompleteTask)
                            .frame(height: 100)
                    }
                }
            }
        }
        
    }
}

#Preview {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return WheelView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}
