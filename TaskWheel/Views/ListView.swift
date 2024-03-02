import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let order: OrderItem
    
    init(order: OrderItem) {
        self.order = order
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(taskViewModel.currentTasks(by: order)) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
                
                ForEach(taskViewModel.currentDoneTasks(by: order)) { task in
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
    ListView(order: .manual)
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
