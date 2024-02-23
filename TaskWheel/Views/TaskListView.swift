import SwiftUI

struct TaskListView: View {

    @EnvironmentObject var taskViewModel: TaskViewModel

    let color = ColorSettings()
    let taskListTitle: String
    
    init(taskListTitle: String) {
        self.taskListTitle = taskListTitle
    }

    var body: some View {
        List {
            ForEach(taskViewModel.taskList) { task in
                NavigationLink(value: task) {
                    TaskRowView(task: task, action: taskViewModel.toggleComplete)
                }
            }
            .listRowBackground(color.background)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.never)
        .foregroundStyle(color.text)
        .navigationDestination(for: TaskModel.self) { task in
            UpdateView(task: task)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(taskListTitle)
                    .font(.headline)
                    .foregroundStyle(color.text)
            }
        }
        .toolbarBackground(color.background, for: .navigationBar)
    }
}

struct TaskRowView: View {
    
    let task: TaskModel
    let action: (TaskModel) -> Void
    
    private let sizePadding: CGFloat = 5
    private let sizeFont: CGFloat = 22
    
    init(task: TaskModel, action: @escaping (TaskModel) -> Void = {_ in }) {
        self.task = task
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: sizePadding * 2) {
            Button(action: {
                action(task)
            }, label: {
                Image(systemName: task.isComplete ? "checkmark.square" : "square")
            })
            .buttonStyle(BorderlessButtonStyle())
            .font(.system(size: sizeFont + 3))
            
            VStack(alignment: .leading, spacing: sizePadding) {
                Text(task.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                if !task.details.isEmpty {
                    Text(task.details)
                        .font(.system(size: sizeFont - 5))
                        .opacity(0.7)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            Spacer()
        }
        .padding([.vertical], sizePadding)
        .font(.system(size: sizeFont))
        .modifier(TaskRowModifier(isComplete: task.isComplete))
    }
}

struct TaskRowModifier: ViewModifier {
    let isComplete: Bool
    let color = ColorSettings()
    
    func body(content: Content) -> some View {
        if isComplete {
            return AnyView(content.strikethrough().foregroundStyle(.gray))
        } else {
            return AnyView(content.foregroundStyle(color.text))
        }
    }
}


#Preview {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let incomplete = TaskModel(title: "first task", isComplete: false, details: "first task details")
    return TaskRowView(task: incomplete)
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let completed = TaskModel(title: "second task", isComplete: true, details: "i'm completed")
    return TaskRowView(task: completed)
}
