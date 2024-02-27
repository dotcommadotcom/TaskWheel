import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView() {
            ForEach(taskViewModel.taskList) { task in
                TaskRowView(task: task, action: taskViewModel.toggleComplete)
            }
        }
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}

#Preview {
    return ListView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}
