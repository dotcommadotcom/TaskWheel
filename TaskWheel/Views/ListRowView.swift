import SwiftUI

struct ListRowView: View {
    
//    @EnvironmentObject var taskViewModel: TaskViewModel
    
    let task: TaskModel
    
    var body: some View {
        HStack {
            Image(systemName: task.isComplete ? "checkmark.square" : "square")
            Text(task.title)
                .font(.title3)
            Spacer()
        }
        .modifier(TaskRowModifier(isComplete: task.isComplete))
    }
}

struct TaskRowModifier: ViewModifier {
    let isComplete: Bool
    
    func body(content: Content) -> some View {
        if isComplete {
            return AnyView(content.strikethrough().foregroundStyle(.gray))
        } else {
            return AnyView(content)
        }
    }
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let incomplete = TaskModel(title: "first task", isComplete: false)
    return ListRowView(task: incomplete)
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let completed = TaskModel(title: "second task", isComplete: true)
    return ListRowView(task: completed)
}
