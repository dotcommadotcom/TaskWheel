import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskViewModel.taskList) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task, action: taskViewModel.toggleComplete)
                            .frame(height: 100)
                    }
                }
            }
        }
        .navigationDestination(for: TaskModel.self) { task in
            UpdateView(task: task)
        }
        
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    WheelView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}
