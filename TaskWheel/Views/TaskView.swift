import SwiftUI

struct TaskView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State var dateInput: Date?
    
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
    private let color = ColorSettings()
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
        VStack(alignment: .leading, spacing: 22) {
            TextField(textDefault, text: $titleInput, axis: .vertical)
                .lineLimit(20)
            
            if showDetails {
                TextField(detailDefault, text: $detailsInput, axis: .vertical)
                    .lineLimit(5)
                    .font(.system(size: 17))
            }
            
            addBarView()
                .buttonStyle(NoAnimationStyle())
                
        }
        .fixedSize(horizontal: false, vertical: true)
        .onSubmit { clickSave() }
    }
    
    private func updateTaskView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            listTitleView()
            
            taskTitleView()
            
            propertyContainerView(task: task)
            
            Spacer()
            
            updateBarView()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .font(.system(size: 20))
        .foregroundStyle(color.text)
        .background(color.background)
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
    
    private func addBarView() -> some View {
        HStack(spacing: 30) {
            detailsButton()
            
            scheduleButton()
            
            priorityButton()
            
            saveButton()
        }
    }
    
    private func detailsButton() -> some View {
        Button {
            showDetails.toggle()
        } label: {
            IconView(icon: .details, size: iconSize)
        }
        .foregroundStyle(!detailsInput.isEmpty ? color.accent : color.text)
    }
    
    private func scheduleButton() -> some View {
        Button {
            showSchedule.toggle()
        } label: {
            IconView(icon: .schedule, size: iconSize)
        }
        .foregroundStyle(dateInput == nil ? color.text : color.accent)
        .popover(isPresented: $showSchedule) {
            VStack(alignment: .leading, spacing: 22) {
                CalendarView(selected: $dateInput, showSchedule: $showSchedule)
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
        .padding(.vertical, 8)
        .onLongPressGesture(minimumDuration: 1) {
            priorityInput = PriorityItem(3)
        }
    }
    
    private func saveButton() -> some View {
        Button {
            clickSave()
        } label: {
            IconView(icon: .save, isSpace: true, size: iconSize)
        }
        .disabled(isTaskEmpty() ? true : false)
        .foregroundStyle(isTaskEmpty() ? .gray : color.text)
    }
    
    private func listTitleView() -> some View {
        Button {
            listsSelected = .lists
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 15))
                Text(taskViewModel.currentTitle())
            }
            .fontWeight(.semibold)
            .foregroundStyle(color.text.opacity(0.8))
        }
        .sheetItem(selected: $listsSelected)
    }
    
    private func taskTitleView() -> some View {
        TextField(titleInput, text: $titleInput, axis: .vertical)
            .lineLimit(5)
            .font(.system(size: 30))
            .strikethrough(task.isDone ? true : false)
            .frame(maxWidth: .infinity)
            .onSubmit {
                saveGoBack()
            }
    }
    
    private func propertyContainerView(task: TaskModel) -> some View {
        VStack(spacing: 15) {
            
            propertyView(.details)
            
            propertyView(.priority)
                .onTapGesture {
                    showPriority.toggle()
                }
            
            propertyView(.schedule)
                .onTapGesture {
                    showSchedule.toggle()
                }
            
        }
    }
    
    private func propertyView(_ property: IconItem) -> some View {
        
        ZStack(alignment: .center) {
            HStack(spacing: 20) {
                IconView(icon: property, size: 20)
                
                switch property {
                case .details: detailsView()
                case .schedule: scheduleView()
                case .priority: priorityView()
                default: Text(property.name)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onSubmit {
                saveGoBack()
            }
        }
        .frame(height: 40)
    }
    
    private func detailsView() -> some View {
        ZStack(alignment: .leading) {
            if detailsInput.isEmpty {
                Text("Add details")
                    .foregroundStyle(color.text.opacity(half))
            }
            TextField(detailsInput, text: $detailsInput, axis: .vertical)
                .lineLimit(5)
        }
    }
    
    private func priorityView() -> some View {
        ZStack(alignment: .leading) {
            Text("Add priority")
                .foregroundStyle(color.text.opacity(half))
                .opacity(priorityInput.rawValue == 3 ? 1 : 0)
            
            TextButtonView(item: .priority(priorityInput))
                .opacity(priorityInput.rawValue == 3 ? 0 : 1)
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
    
    private func scheduleView() -> some View {
        ZStack(alignment: .leading) {
            Text("Add date/time")
                .foregroundStyle(color.text.opacity(half))
                .opacity(dateInput == nil ? 1 : 0)
            
            if let date = dateInput {
                TextButtonView(item: .date(date.string()))
            }
        }
        .popover(isPresented: $showSchedule) {
            VStack(alignment: .leading, spacing: 22) {
                CalendarView(selected: $dateInput, showSchedule: $showSchedule)
            }
            .font(.system(size: 22))
            .padding(30)
            .presentSheet($sheetHeight)
        }
    }
    
    private func updateBarView() -> some View {
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
    
}

extension TaskView {
    
    private func clickSave() {
        taskViewModel.addTask(title: titleInput, details: detailsInput, priority: priorityInput.rawValue, date: dateInput)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isTaskEmpty() -> Bool {
        return titleInput.isEmpty && detailsInput.isEmpty && priorityInput.rawValue == 3 && dateInput == nil
    }
    
    private func clickProperty(_ property: IconItem) {
        switch property {
        case .priority:
            showPriority.toggle()
        default: return
        }
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
    
    return NavigationStack {
        TaskView()
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
}
