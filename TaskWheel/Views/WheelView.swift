import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskViewModel.taskList) { task in
                    TaskRowView(task: task, action: taskViewModel.toggleComplete)
                        .frame(height: 100)
                }
            }
        }
        
    }
}

#Preview {
    return WheelView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}
