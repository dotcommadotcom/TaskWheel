import SwiftUI
import DequeModule

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(taskViewModel.currentTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
                
                ForEach(taskViewModel.currentDoneTasks()) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
}

struct TaskRowView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var dateInput: Date?
    
    let task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
        _dateInput = State(initialValue: self.task.date)
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            Button {
                taskViewModel.toggleDone(task)
            } label: {
                Icon(this: .complete, isAlt: task.isDone, isFill: task.priority != 3 && !task.isDone, size: 22)
                    .foregroundStyle(task.isDone ? Color.text.opacity(0.5) : PriorityItem(task.priority).color)
            }
            .alignmentGuide(.firstTextBaseline) { dimension in
                return dimension[.bottom] - 3
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(task.title.isEmpty ? " " : task.title)
                    .lineLimit(1)
                    

                if !task.details.isEmpty {
                    Text(task.details)
                        .font(.system(size: 20, weight: .light))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                }
                
                if !task.isDone {
                    ScheduleButton(date: $dateInput)
                    .font(.system(size: 20))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .font(.system(size: 23))
        .mark(isDone: task.isDone)
        .onChange(of: dateInput) { _, _ in
            taskViewModel.resetDate(of: task)
        }
    }
}

struct TaskRowModifier: ViewModifier {
    let isDone: Bool
    
    func body(content: Content) -> some View {
        if isDone {
            return AnyView(content.strikethrough().foregroundStyle(Color.text.opacity(0.5)))
        } else {
            return AnyView(content.foregroundStyle(Color.text))
        }
    }
}

extension View {
    func mark(isDone: Bool) -> some View {
        self
            .modifier(TaskRowModifier(isDone: isDone))
    }
}

#Preview {
    let taskList = TaskListModel(title: "my tasks")
    let tasks: Deque<TaskModel> = [
        TaskModel(title: "this is the most simple task", ofTaskList: taskList.id, priority: 0),
        TaskModel(title: "this is the most simple task", ofTaskList: taskList.id, priority: 0),
        TaskModel(title: "this is the most simple task", ofTaskList: taskList.id, priority: 0),
        TaskModel(title: "this is the most simple task", ofTaskList: taskList.id, priority: 0),
        TaskModel(title: "", ofTaskList: taskList.id, priority: 1),
        TaskModel(title: "", ofTaskList: taskList.id, details: "just details", priority: 2),
        TaskModel(title: "", ofTaskList: taskList.id, date: date(2023, 3, 4)),
        TaskModel(title: "task with date", ofTaskList: taskList.id, priority: 0, date: date(2023, 3, 4)),
        TaskModel(title: "this is a long text hat i am hoping will overflow", ofTaskList: taskList.id, details: "these are details that should also overflow just to show the fullest version of a task", priority: 1, date: date(2023, 6, 28)),
        TaskModel(title: "", ofTaskList: taskList.id, details: "these are details that does not overflow ", priority: 0, date: date(2023, 3, 4)),
        TaskModel(title: "full but completed", ofTaskList: taskList.id, isDone: true, details: "again, full but completed but want to show how details can overflow", priority: 0, date: date(2023, 3, 3)),
    ]
    
    return ZStack {
        Color.background.ignoresSafeArea()
        
        ListView()
            .environmentObject(TaskViewModel(tasks, Deque([taskList])))
            .preferredColorScheme(.dark)
    }
}




#Preview {
    ListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
