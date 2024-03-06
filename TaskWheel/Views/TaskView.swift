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
    @State private var dateSelected: Date? = nil
    @State private var isPriorityReset = false
    @State private var sheetHeight: CGFloat = .zero
    
    let task: TaskModel
    let isAdd: Bool
    private let updateTabs: [IconItem] = [.delete, .complete]
    private let half: Double = 0.5
    private let iconSize: CGFloat = 22
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details"
    
    init(task: TaskModel?, _ isNew: Bool = false) {
        self.task = task ?? TaskModel(title: "")
        self.isAdd = isNew
        _titleInput = State(initialValue: self.task.title)
        _detailsInput = State(initialValue: self.task.details)
        _dateInput = State(initialValue: self.task.date)
        _priorityInput = State(initialValue: PriorityItem(self.task.priority))
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
            listTitleView()
            
            taskTitleView()
            
            if showDetails {
                detailsView()
            }
            
            scheduleTextButton()
            
            HStack(spacing: 30) {
                detailsButton()
                
                priorityButton()
                
                scheduleView()
                
                saveButton()
            }
            .buttonStyle(NoAnimationStyle())
        }
        .font(.system(size: 20))
        .onSubmit { clickSave() }
    }
    
    private func updateTaskView() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            listTitleView()
            
            taskTitleView()
            
            detailsView()
            
            priorityView()
            
            scheduleView()
            
            Spacer()
            
            BarContainerView(selected: $barSelected, padding: 0) {
                ForEach(updateTabs, id: \.self) { tab in
                    IconView(icon: tab, isSpace: tab == updateTabs.last, isAlt: true)
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
        .font(.system(size: 20))
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
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
        }
    }
    
}

extension TaskView {
    
    private func listTitleView() -> some View {
        Button {
            listsSelected = .lists
        } label: {
            HStack(alignment: .center) {
                IconView(icon: .move, size: 15)
                
                Text(taskViewModel.currentTitle())
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Color.text.opacity(0.8))
        }
        .sheetItem(selected: $listsSelected)
    }
    
    private func taskTitleView() -> some View {
        ZStack(alignment: .leading) {
            if titleInput.isEmpty {
                Text("What now?")
                    .foregroundStyle(Color.text.opacity(0.5))
            }
            
            TextField(titleInput, text: $titleInput, axis: .vertical)
                .lineLimit(5)
                .strikethrough(task.isDone ? true : false)
            
        }
        .font(.system(size: 25))
        .frame(maxWidth: .infinity)
        .onSubmit {
            saveGoBack()
        }
    }
    
    private func detailsView() -> some View {
        HStack(spacing: 20) {
            if !isAdd {
                IconView(icon: .details, size: iconSize)
            }
            
            ZStack(alignment: .leading) {
                if detailsInput.isEmpty {
                    Text("Add details")
                        .foregroundStyle(Color.text.opacity(0.5))
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
            IconView(icon: .details, size: iconSize)
        }
    }
    
    private func priorityView() -> some View {
        HStack(spacing: 20) {
            IconView(icon: .priority, size: iconSize)
            
            ZStack(alignment: .leading) {
                Text("Add priority")
                    .foregroundStyle(Color.text.opacity(half))
                    .opacity(priorityInput.rawValue == 3 ? 1 : 0)
                
                TextButtonView(priority: priorityInput)
                    .opacity(priorityInput.rawValue == 3 ? 0 : 1)
            }
        }
        .frame(height: 40)
        .onTapGesture {
            showPriority.toggle()
        }
        .popover(isPresented: $showPriority) {
            VStack(alignment: .leading, spacing: 22) {
                PrioritySheetView(selected: $priorityInput, showPriority: $showPriority)
            }
            .font(.system(size: 22))
            .padding(30)
            .presentSheet($sheetHeight)
        }
    }
    
    private func priorityButton() -> some View {
        Button {
            priorityInput = PriorityItem((priorityInput.rawValue + 3) % 4)
        } label: {
            IconView(icon: .priority, isAlt: priorityInput.rawValue != 3, size: iconSize)
        }
        .foregroundStyle(priorityInput.color)
        .onLongPressGesture(minimumDuration: 1) {
            priorityInput = PriorityItem(3)
        }
    }
    
    private func scheduleView() -> some View {
        HStack(spacing: 20) {
            IconView(icon: .schedule, size: iconSize)
            
            if !isAdd {
                ZStack(alignment: .leading) {
                    Text("Add date/time")
                        .foregroundStyle(Color.text.opacity(half))
                        .opacity(dateInput == nil ? 1 : 0)
                    
                    scheduleTextButton()
                }
            }
        }
        .frame(height: 40)
        .onTapGesture {
            showSchedule.toggle()
        }
        .popover(isPresented: $showSchedule) {
            VStack(alignment: .leading, spacing: 22) {
                CalendarView(selected: $dateInput, showSchedule: $showSchedule)
            }
            .padding(30)
            .presentSheet($sheetHeight)
        }
    }
    
    private func scheduleTextButton() -> some View {
        if let date = dateInput {
            return AnyView(TextButtonView(date: date))
        }
        return AnyView(EmptyView())
    }
    
    private func saveButton() -> some View {
        Button {
            clickSave()
        } label: {
            IconView(icon: .save, isSpace: true, size: iconSize)
        }
        .disabled(isTaskEmpty() ? true : false)
        .foregroundStyle(isTaskEmpty() ? Color.text.opacity(0.5) : Color.text)
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
        if task.title != titleInput ||
            task.ofTaskList !=  taskViewModel.currentTaskList().id ||
            task.details != detailsInput ||
            task.priority != priorityInput.rawValue ||
            task.date != dateInput {
            taskViewModel.update(
                this: task,
                title: titleInput,
                ofTaskList: taskViewModel.currentTaskList().id,
                details: detailsInput,
                priority: priorityInput.rawValue,
                date: dateInput
            )
        }
        navigation.goBack()
    }
}

struct NoAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
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
