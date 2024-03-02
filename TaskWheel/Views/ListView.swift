import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(taskViewModel.currentTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
                
                ForEach(taskViewModel.currentDoneTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    ListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
