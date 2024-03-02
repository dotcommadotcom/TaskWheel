import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let order: OrderItem
    
    init(order: OrderItem) {
        self.order = order
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskViewModel.currentTasks(by: order)) { task in
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
    WheelView(order: .manual)
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
