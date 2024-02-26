import SwiftUI

struct ListView: View {
    
    let taskList: [String]
    
    var body: some View {
        List {
            ForEach(taskList, id: \.self) { task in
                TaskView(task: task)
            }
        }
    }
}



struct TaskView: View {
    
    let task: String
    
    var body: some View {
        HStack() {
            Button(action: {}, label: {
                Image(systemName: "checkmark.square")
            })
            
            Text(task)
            
            Spacer()
        }
    }
}


#Preview {
    let sampleTasks = (1...10).map { "Task \($0)" }
    
    return ListView(taskList: sampleTasks)
}
