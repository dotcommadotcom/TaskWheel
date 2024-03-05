import SwiftUI

struct WheelView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selected: Int = 0
    
    var body: some View {
        Picker("wheel", selection: $selected) {
            ForEach(taskViewModel.currentTasks()) { task in
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
    WheelView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
