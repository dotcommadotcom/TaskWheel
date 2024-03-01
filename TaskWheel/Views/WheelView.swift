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
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
