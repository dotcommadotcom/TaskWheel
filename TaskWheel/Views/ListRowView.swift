import SwiftUI

struct ListRowView: View {
    let task: TaskModel
    
    var body: some View {
        HStack {
            Image(systemName: task.isComplete ? "checkmark.square" : "square")
            Text(task.title)
                .font(.title3)
            Spacer()
        }
    }
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let incomplete = TaskModel(title: "first task", isComplete: false)
    return ListRowView(task: incomplete)
        .previewLayout(.sizeThatFits)
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let completed = TaskModel(title: "second task", isComplete: true)
    return ListRowView(task: completed)
        .previewLayout(.sizeThatFits)
}
