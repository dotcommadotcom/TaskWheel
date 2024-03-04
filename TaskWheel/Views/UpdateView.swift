import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State private var showLists = false
    @State private var showPriority = false
    @State private var barSelected: IconItem? = nil
    @State private var selectedDate = Date()
    @State private var sheetHeight: CGFloat = .zero
    
    let task: TaskModel
    private let color = ColorSettings()
    private let updateTabs: [IconItem] = [.delete, .complete]
    
    init(task: TaskModel) {
        self.task = task
        _titleInput = State(initialValue: task.title)
        _detailsInput = State(initialValue: task.details)
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
            .foregroundStyle(color.text.opacity(0.5))
        }
        .popover(isPresented: $showLists) {
            VStack(alignment: .leading, spacing: 22) {
                
                Text("Move to")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color.text.opacity(0.5))
                
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
            
            propertyView(.details, isEmpty: false)
            
            Button {
            } label: {
                propertyView(.schedule, isEmpty: true, defaultText: "Set schedule")
            }
            
            Button {
                showPriority.toggle()
            } label: {
                propertyView(.priority, isEmpty: task.priority == 4, defaultText: "Set priority")
            }
            .overlay(alignment: .top) {
                if showPriority {
                    PriorityView(selected: $priorityInput, showPriority: $showPriority)
                        .offset(x: 20, y: 40)
//                        .padding(40)
                }
            }
            
//            .popover(isPresented: $showPriority) {
//                PriorityView(selected: $priorityInput)
//                    .presentationCompactAdaptation(.popover)
//                    .presentationBackground(color.background)
//            }
        }
    }
    
    private func propertyView(_ property: IconItem, isEmpty: Bool, defaultText: String = "") -> some View {
        
        HStack(spacing: 13) {
            Image(systemName: property.text)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            if isEmpty {
                Text(defaultText)
                    .foregroundStyle(.gray.opacity(0.6))
            } else {
                switch property {
                case .details:
                    TextField(detailsInput.isEmpty ? "Add details" : detailsInput, text: $detailsInput, axis: .vertical)
                        .foregroundStyle(detailsInput.isEmpty ? .gray : color.text)
                        .lineLimit(5)
                        .onSubmit {
                            saveGoBack()
                        }
                case .schedule:
                    dateView()
                case .priority:
                    Text(priorityInput.text)
                    
                default:
                    Text(property.text)
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func dateView() -> some View {
        DatePicker("date", selection: $selectedDate)
            .datePickerStyle(.automatic)
    }
    
}

extension UpdateView {
    
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
