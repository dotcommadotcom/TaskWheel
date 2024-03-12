import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
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

extension TaskListView {
    
    private func taskListRowView(taskList: TaskListModel) -> some View {
        
        let highlight = taskList.id == taskViewModel.currentId()
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? Color.accent : Color.text)
            
            Text(taskList.title)
                .fontWeight(highlight ? .bold : .regular)
            
            Spacer()
            
            Text(String(taskList.count))
                .foregroundStyle(Color.text.opacity(0.5))
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension TaskListView {
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
    }
}

#Preview {
    TaskListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
