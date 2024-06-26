import SwiftUI
import DequeModule

struct ListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
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
    @State var dateInput: Date? = nil
    @State private var showSchedule = false
    
    let task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            checkmarkButton()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(task.title.isEmpty ? " " : task.title)
                    .lineLimit(1)
                    .alignText()
    
                if !task.details.isEmpty {
                    Text(task.details).smallFont()
                        .fontWeight(.light)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                if !task.isDone && task.date != nil {
                    scheduleButton()
                }
            }
        }
        .padding(10).padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .mediumFont()
        .mark(isDone: task.isDone)
        .onChange(of: dateInput) { _, _ in
            changeDate()
        }
    }
}

extension TaskRowView {
    private func checkmarkButton() -> some View {
        Button {
            clickDone()
        } label: {
            Icon(
                this: .done,
                style: IconOnly(),
                color: checkmarkColor(),
                isAlt: task.isDone,
                isFill: task.priority != 3 && !task.isDone
            )
        }
        .alignIcon()
    }
    
    private func scheduleButton() -> some View {
        RoundedButton(
            task.date?.relative() ?? "",
            textColor: task.date?.isPast() ?? false ? Color.past : Color.text
        ) {
            clickSchedule()
        } action: {
            resetDate()
        }
        .popSchedule(show: $showSchedule, input: $dateInput)
    }
}

extension TaskRowView {
    
    private func clickDone() {
        taskViewModel.toggleDone(task)
    }
    
    private func checkmarkColor() -> Color {
        return task.isDone ? Color.text.opacity(0.5) :
        task.priority != 3 ? PriorityItem(task.priority).color :
        Color.text
    }
    
    private func clickSchedule() {
        showSchedule.toggle()
    }
    
    private func changeDate() {
        taskViewModel.changeDate(of: task, to: dateInput)
    }
    
    private func resetDate() {
        taskViewModel.changeDate(of: task, to: nil)
    }
}

#Preview("variations") {
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



