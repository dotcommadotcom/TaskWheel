import SwiftUI

struct TaskView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State var dateInput: Date?
    
    @State private var listsSelected: IconItem? = nil
    @State private var showPriority = false
    @State private var showSchedule = false
    
    let task: TaskModel
    let isAdd: Bool
    
    private let options: [IconItem] = [.delete, .done]
    
    init(task: TaskModel?, _ isNew: Bool = false) {
        self.task = task ?? TaskModel(title: "")
        self.isAdd = isNew
        _titleInput = State(initialValue: self.task.title)
        _detailsInput = State(initialValue: self.task.details)
        _priorityInput = State(initialValue: PriorityItem(self.task.priority))
        _dateInput = State(initialValue: self.task.date)
    }
    
    init() {
        self.init(task: nil, true)
    }
    
    var body: some View {
        ZStack {
            if isAdd {
                addTaskView()
                    .onSubmit {
                        clickAddSave()
                    }
            } else {
                updateTaskView()
                    .onSubmit {
                        clickUpdateSave()
                    }
            }
        }
        .popPriority(show: $showPriority, input: $priorityInput)
        .popSchedule(show: $showSchedule, input: $dateInput)
        .onChange(of: dateInput) { _, _ in
            changeDate()
            taskViewModel.printDate(of: task)
        }
    }
}

extension TaskView {
    
    private func addTaskView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleView(size: .small, fontWeight: .medium, isGreyed: true)
            
            taskTitleView()
            
            detailsView()
            
            if dateInput != nil {
                ScheduleButton(date: $dateInput)
            }
            
            addBarView()
        }
        .smallFont()
    }
    
    private func addBarView() -> some View {
        HStack(spacing: 30) {
            priorityView()
            
            scheduleView()
            
            Spacer()
            
            Button {
                clickAddSave()
            } label: {
                Icon(this: .save, style: IconOnly())
            }
            .disableClick(if: isTaskEmpty())
        }
    }
    
    private func updateTaskView() -> some View {
        VStack(alignment: .leading, spacing: 25) {
            TitleView(size: .small, fontWeight: .medium, isGreyed: true)
            
            taskTitleView()
            
            detailsView()
            
            priorityView()
            
            scheduleView()
                .frame(height: 40)
            
            Spacer()
            
            updateBarView()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .smallFont()
        .foregroundStyle(Color.text)
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    clickUpdateSave()
                }) {
                    Icon(this: .back, style: IconOnly(), color: Color.text)
                }
                .foregroundStyle(Color.text)
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
        }
    }
    
    private func updateBarView() -> some View {
        let zippedOptions = Array(zip(options, [clickDelete, clickDone]))
        
        return HStack(spacing: 30) {
            ForEach(zippedOptions, id: \.0) { icon, action in
                if icon == .done {
                    Spacer()
                }
                
                Button(action: action) {
                    Icon(this: icon, size: .custom(25), style: IconOnly())
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension TaskView {
    
    private func taskTitleView() -> some View {
        ZStack(alignment: .leading) {
            if titleInput.isEmpty {
                Text("What now?").greyed()
            }
            
            TextField(titleInput, text: $titleInput, axis: .vertical)
                .lineLimit(5)
                .strikethrough(task.isDone ? true : false)
            
        }
        .largeFont()
        .frame(maxWidth: .infinity)
    }
    
    private func detailsView() -> some View {
        Icon(this: .details,
             style: Default(spacing: 20)
        ) {
            ZStack(alignment: .leading) {
                if detailsInput.isEmpty {
                    Text("Add details").greyed()
                }
                TextField(detailsInput, text: $detailsInput, axis: .vertical)
                    .lineLimit(10)
            }
        }
    }
    
    private func priorityView() -> some View {
        Button {
            clickPriority()
        } label: {
            Icon(this: .priority,
                 style: isAdd ? IconOnly() : Default(spacing: 20),
                 color: isAdd && priorityInput != .no ? priorityInput.color : Color.text,
                 isAlt: isAdd && priorityInput != .no
            ) {
                ZStack(alignment: .leading) {
                    Text("Add priority").greyed()
                        .opacity(priorityInput.rawValue == 3 ? 1 : 0)
                    
                    PriorityButton(priority: $priorityInput)
                        .opacity(priorityInput.rawValue == 3 ? 0 : 1)
                }
            }
        }
        .foregroundStyle(isAdd ? priorityInput.color : Color.text)
        .onLongPressGesture(minimumDuration: 0.5) {
            priorityInput = PriorityItem(3)
        }
    }
    
    private func scheduleView() -> some View {
        Button {
            clickSchedule()
        } label: {
            Icon(this: .schedule,
                 style: isAdd ? IconOnly() : Default(spacing: 20)
            ) {
                ZStack(alignment: .leading) {
                    Text("Add due date").greyed()
                        .opacity(dateInput == nil ? 1 : 0)
                    
                    if dateInput != nil {
                        ScheduleButton(date: $dateInput)
                    }
                }
            }
        }
    }
}

extension TaskView {
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty && priorityInput.rawValue == 3 && dateInput == nil
    }
    
    private func clickAddSave() {
        if !isTaskEmpty() {
            taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput.rawValue, date: dateInput)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickPriority() {
        if isAdd {
            priorityInput = PriorityItem((priorityInput.rawValue + 3) % 4)
        } else {
            showPriority.toggle()
        }
    }
    
    private func clickSchedule() {
        showSchedule.toggle()
    }
    
    private func changeDate() {
        if dateInput == nil {
            taskViewModel.resetDate(of: task)
        } else {
            taskViewModel.update(this: task, date: dateInput)
        }
    }
    
    private func clickDelete() {
        taskViewModel.delete(this: task)
        navigation.goBack()
    }
    
    private func clickDone() {
        taskViewModel.toggleDone(task)
        navigation.goBack()
    }
    
    private func clickUpdateSave() {
//        if dateInput == nil {
//            taskViewModel.resetDate(of: task)
//        } else {
//            taskViewModel.update(this: task, date: dateInput)
//        }
        
        taskViewModel.update(
            this: task,
            title: titleInput,
            ofTaskList: taskViewModel.currentId(),
            details: detailsInput,
            priority: priorityInput.rawValue,
            date: dateInput
        )

        navigation.goBack()
    }
}

#Preview("add task", traits: .sizeThatFitsLayout) {
    let tasks = TaskViewModel.tasksExamples()
    
    return ZStack {
        Color.gray.opacity(0.5).ignoresSafeArea()
        
        NavigationStack {
            TaskView()
        }
        .padding()
    }
    .environmentObject(TaskViewModel(tasks, TaskViewModel.examples))
    .environmentObject(NavigationCoordinator())
}

#Preview("empty task", traits: .sizeThatFitsLayout) {
    let tasks = TaskViewModel.tasksExamples()
    let empty = tasks[1]
    
    return NavigationStack {
        TaskView(task: empty)
    }
    .environmentObject(TaskViewModel(tasks, TaskViewModel.examples))
    .environmentObject(NavigationCoordinator())
}

#Preview("full task", traits: .sizeThatFitsLayout) {
    let tasks = TaskViewModel.tasksExamples()
    let full = tasks[3]
    
    return NavigationStack {
        TaskView(task: full)
    }
    .environmentObject(TaskViewModel(tasks, TaskViewModel.examples))
    .environmentObject(NavigationCoordinator())
    .preferredColorScheme(.dark)
}
