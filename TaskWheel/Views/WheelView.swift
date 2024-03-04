import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = 0
    
    let order: OrderItem
    
    init(order: OrderItem) {
        self.order = order
    }
    
    var body: some View {
        Picker("wheel", selection: $selected) {
            ForEach(taskViewModel.currentTasks(by: order)) { task in
                HStack {
                    Text(task.title)
                        .font(.system(size: 23))
                    Spacer()
                }
                .padding()
            }
        }
        .pickerStyle(.wheel)
        .frame(maxHeight: .infinity, alignment: .leading)
    }
    
}


#Preview {
    WheelView(order: .manual)
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
