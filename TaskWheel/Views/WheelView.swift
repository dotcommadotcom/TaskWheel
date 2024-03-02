import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskViewModel.currentTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
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
