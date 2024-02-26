import SwiftUI


struct TaskListTitleView: View {
    
    let taskListTitle: String
    
    var body: some View {
        Text(taskListTitle)
    }
}


#Preview {
    TaskListTitleView(taskListTitle: "sample task list")
}
