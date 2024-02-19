import SwiftUI

struct ListRowView: View {
    
    let task: TaskModel
    let action: (TaskModel) -> Void
    
    init(task: TaskModel, action: @escaping (TaskModel) -> Void = {_ in }) {
        self.task = task
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(action: {
                action(task)
            }, label: {
                Image(systemName: task.isComplete ? "checkmark.square" : "square")
            })
            .onTapGesture { }
            .buttonStyle(BorderlessButtonStyle())
            
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
            return AnyView(content.foregroundStyle(.primary))
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
