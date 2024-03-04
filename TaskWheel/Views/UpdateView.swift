import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var dateInput: Date?
    @State var priorityInput: PriorityItem
    @State private var showLists = false
    @State private var showPriority = false
    @State private var barSelected: IconItem? = nil
    @State private var selectedDate: Date? = nil
    @State private var sheetHeight: CGFloat = .zero
    
    let task: TaskModel
    private let color = ColorSettings()
    private let updateTabs: [IconItem] = [.delete, .complete]
    private let half: Double = 0.5
    
    init(task: TaskModel) {
        self.task = task
        _titleInput = State(initialValue: task.title)
        _detailsInput = State(initialValue: task.details)
        _dateInput = State(initialValue: task.date)
        _priorityInput = State(initialValue: PriorityItem(task.priority))
    }
    
    var body: some View {
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

extension UpdateView {
    
    private func listTitleView() -> some View {
        Button {
            showLists.toggle()
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 15))
                Text(taskViewModel.currentTitle())
            }
            .fontWeight(.bold)
            .foregroundStyle(color.text.opacity(half))
        }
        .popover(isPresented: $showLists) {
            VStack(alignment: .leading, spacing: 22) {
                
                Text("Move to")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color.text.opacity(half))
                
                TaskListsView()
            }
            .font(.system(size: 22))
            .padding(30)
            .presentSheet($sheetHeight)
        }
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
        VStack(spacing: 20) {
            
            propertyView(.details)
            
            propertyView(.schedule)
            
            propertyView(.priority)
            .overlay(alignment: .top) {
                if showPriority {
                    PriorityView(selected: $priorityInput, showPriority: $showPriority)
                        .offset(x: 20, y: 40)
                }
            }
        }
    }
    
    private func propertyView(_ property: IconItem) -> some View {
        
        HStack(spacing: 13) {
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
    
    private func scheduleView() -> some View {
        if let date = dateInput {
            Text(string(from: date))
        } else {
            Text("Add date/time")
                .foregroundStyle(color.text.opacity(half))
        }
    }
    
    private func priorityView() -> some View {
        if priorityInput.rawValue != 3 {
            Text(priorityInput.text)
        } else {
            Text("Add priority")
                .foregroundStyle(color.text.opacity(half))
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

extension UpdateView {
    
    func string(from date: Date) -> String {
        // Format the date as needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
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
        if task.title != titleInput || task.ofTaskList !=  taskViewModel.currentTaskList().id || task.details != detailsInput || task.priority != priorityInput.rawValue {
            taskViewModel.update(
                this: task,
                title: titleInput,
                ofTaskList: taskViewModel.currentTaskList().id,
                details: detailsInput,
                priority: priorityInput.rawValue
            )
        }
        navigation.goBack()
    }
}

#Preview("empty task", traits: .sizeThatFitsLayout) {
    let tasks = TaskViewModel.tasksExamples()
    let empty = tasks[1]
    
    return NavigationStack {
        UpdateView(task: empty)
    }
    .environmentObject(TaskViewModel(tasks, TaskViewModel.examples))
    .environmentObject(NavigationCoordinator())
}

#Preview("full task", traits: .sizeThatFitsLayout) {
    let tasks = TaskViewModel.tasksExamples()
    let full = tasks[3]
    
    return NavigationStack {
        UpdateView(task: full)
    }
    .environmentObject(TaskViewModel(tasks, TaskViewModel.examples))
    .environmentObject(NavigationCoordinator())
}
