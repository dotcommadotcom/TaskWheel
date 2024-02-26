import SwiftUI

struct ListView: View {
    
    let taskList: [String]
    
    var body: some View {
        List {
            ForEach(taskList, id: \.self) { task in
                TaskRowView(task: task)
            }
        }
    }
}

#Preview {
    let sampleTasks = (1...10).map { "Task \($0)" }
    
    return ListView(taskList: sampleTasks)
}
