import SwiftUI

struct WheelView: View {
    
    let taskList: [String]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(taskList, id: \.self) { task in
                    TaskRowView(task: task)
                        .frame(height: 100)
                }
            }
        }
        
    }
}

#Preview {
    let sampleTasks = (1...10).map { "Task \($0)" }
    
    return WheelView(taskList: sampleTasks)
}
