import SwiftUI

struct TaskView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State var dateInput: Date?
    
    @FocusState private var detailsFocused: Bool
    @State private var showDetails = false
    @State private var showPriority = false
    @State private var showSchedule = false
    @State private var listsSelected: IconItem? = nil
    
    @State private var barSelected: IconItem? = nil
    @State private var isDateReset: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    
    let task: TaskModel
    let isAdd: Bool
    private let updateTabs: [IconItem] = [.delete, .complete]
    private let half: Double = 0.5
    private let iconSize: SizeItem = .medium
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details"
    
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
        if isAdd {
            addTaskView()
        } else {
            updateTaskView()
        }
    }
}

extension TaskView {
    
    private func addTaskView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleView(size: .small, fontWeight: .medium, isGreyed: true)
            
            taskTitleView()
            
            if showDetails {
                detailsView()
            }
            
            ScheduleButton(date: $dateInput)
            
            HStack(spacing: 30) {
                detailsButton()
                
                priorityButton()
                
                scheduleView()
                
                saveButton()
            }
            .noAnimation()
        }
        .smallFont()
        .onSubmit { clickSave() }
    }
    
    private func updateTaskView() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            TitleView(size: .small, fontWeight: .medium, isGreyed: true)
            
            taskTitleView()
            
            detailsView()
            
            priorityView()
            
            scheduleView()
            
            Spacer()
            
            HStack(spacing: 30) {
                ForEach(updateTabs, id: \.self) { tab in
                    Icon(this: tab, isSpace: tab == updateTabs.last, isAlt: true)
                        .onTapGesture {
                            switch tab {
                            case .complete: clickComplete()
                            case .delete: clickDelete()
                            default: {}()
                            }
                        }
                }
            }
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
                    saveGoBack()
                }) {
                    Image(systemName: "arrow.backward")
                }
                .foregroundStyle(Color.text)
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
        }
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
        .onSubmit {
            saveGoBack()
        }
    }
    
    private func detailsView() -> some View {
        HStack(spacing: 20) {
            if !isAdd {
                Icon(this: .details, size: iconSize)
            }
            
            ZStack(alignment: .leading) {
                if detailsInput.isEmpty {
                    Text("Add details").greyed()
                }
                TextField(detailsInput, text: $detailsInput, axis: .vertical)
                    .focused($detailsFocused)
                    .lineLimit(10)
            }
        }
        .frame(height: 40)
        .onTapGesture {
            detailsFocused = true
        }
        .onSubmit {
            saveGoBack()
        }
        
    }
    
    private func detailsButton() -> some View {
        Button {
            showDetails = true
        } label: {
            Icon(this: .details, size: iconSize)
        }
    }
    
    private func priorityView() -> some View {
        HStack(spacing: 20) {
            Icon(this: .priority, size: iconSize)
            
            ZStack(alignment: .leading) {
                Text("Add priority").greyed()
                    .opacity(priorityInput.rawValue == 3 ? 1 : 0)
                
                PriorityButton(priority: $priorityInput)
                    .opacity(priorityInput.rawValue == 3 ? 0 : 1)
            }
        }
        .frame(height: 40)
        .onTapGesture {
            showPriority.toggle()
        }
        .popPriority(show: $showPriority, input: $priorityInput)
    }
    
    private func priorityButton() -> some View {
        Button {
            priorityInput = PriorityItem((priorityInput.rawValue + 3) % 4)
        } label: {
            Icon(this: .priority, isAlt: priorityInput.rawValue != 3, size: iconSize)
        }
        .foregroundStyle(priorityInput.color)
        .onLongPressGesture(minimumDuration: 1) {
            priorityInput = PriorityItem(3)
        }
    }
    
    private func scheduleView() -> some View {
        HStack(spacing: 20) {
            Icon(this: .schedule, size: iconSize)
            
            if !isAdd {
                ZStack(alignment: .leading) {
                    Text("Add date/time").greyed()
                        .opacity(dateInput == nil ? 1 : 0)
                    
//                    if dateInput != nil {
                    ScheduleButton(date: $dateInput)
//                    }
                }
            }
        }
        .frame(height: 40)
        .onTapGesture {
            showSchedule.toggle()
        }
        .popSchedule(show: $showSchedule, input: $dateInput)
//        .onChange(of: dateInput) { old, new in
//            if old != nil && new == nil {
//                taskViewModel.resetDate(of: task)
//                taskViewModel.printDate(of: task)
//                print("\(old) to \(new)")
//            }
//        }
    }

    private func saveButton() -> some View {
        Button {
            clickSave()
        } label: {
            Icon(this: .save, isSpace: true, size: iconSize)
        }
        .disableClick(if: isTaskEmpty())
    }
}

extension TaskView {
    
    private func clickSave() {
        taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput.rawValue, date: dateInput)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty && priorityInput.rawValue == 3 && dateInput == nil
    }
    
    private func clickComplete() {
        taskViewModel.toggleDone(task)
        saveGoBack()
    }
    
    private func clickDelete() {
        taskViewModel.delete(this: task)
        saveGoBack()
    }
    
    private func saveGoBack() {
        
        if dateInput == .distantPast {
            taskViewModel.resetDate(of: task)
        }
        
        taskViewModel.update(
            this: task,
            title: titleInput,
            ofTaskList: taskViewModel.currentId(),
            details: detailsInput,
            priority: priorityInput.rawValue
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
