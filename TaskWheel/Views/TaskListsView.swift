import SwiftUI

struct TaskListsView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    private let color = ColorSettings()
    
    var body: some View {
        LazyVStack(spacing: 22) {
            ForEach(taskViewModel.taskLists) { taskList in
                taskListRowView(taskList: taskList)
                    .onTapGesture {
                        switchTaskList(to: taskList)
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}

extension TaskListsView {
    
    private func taskListRowView(taskList: TaskListModel) -> some View {
        
        let highlight = taskList.id == taskViewModel.currentTaskList().id
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? color.accent : color.text)
            
            Text(taskList.title)
                .fontWeight(highlight ? .bold : .regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension TaskListsView {
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
    }
}

#Preview {
    TaskListsView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
