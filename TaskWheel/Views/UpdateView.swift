import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    let task: TaskModel
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State private var showPriority = false
    
    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let bottomTabs: [IconItem] = [.complete, .delete, .save]
    
    init(task: TaskModel) {
        self.task = task
        _titleInput = State(initialValue: task.title)
        _detailsInput = State(initialValue: task.details)
        _priorityInput = State(initialValue: PriorityItem(task.priority))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(taskViewModel.getCurrentTitle())
                .fontWeight(.bold)
                .foregroundStyle(color.text.opacity(0.6))
            
            TextField(titleInput.isEmpty ? textDefault : titleInput, text: $titleInput, axis: .vertical)
                .lineLimit(5)
                .font(.system(size: 30))
                .strikethrough(task.isComplete ? true : false)
                .frame(maxWidth: .infinity)
            
            propertyContainerView(task: task)
            
            Spacer()
            
            bottomTabView()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .font(.system(size: 20))
        .background(color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    navigation.goBack()
                }) {
                    Image(systemName: "arrow.backward")
                }
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
        }
        .foregroundStyle(color.text)
        
    }
}

extension UpdateView {
    
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
            .popover(isPresented: $showPriority) {
                PriorityView(selected: $priorityInput)
                    .presentationCompactAdaptation(.popover)
                    .presentationBackground(color.background)
            }
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
                    
                case .priority:
                    Text(priorityInput.text)
                        
                    
                default:
                    Text(property.text)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func bottomTabView() -> some View {
        HStack(spacing: 30) {
            ForEach(bottomTabs, id: \.self) { tab in
                var action: () -> Void {
                    switch tab {
                    case .complete: return clickComplete
                    case .delete: return clickDelete
                    case .save: return clickSave
                    default: return {}
                    }
                }
                tabView(tab, isSpace: tab == bottomTabs.last, action: action)
            }
        }
        .foregroundStyle(color.accent)
        .font(.system(size: 25))
    }
    
    private func tabView(_ tab: IconItem, isSpace: Bool, action: @escaping () -> Void) -> some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Button (action: action) {
                Image(systemName: tab.alternative)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: tab == .save ? 29 : 25)
            }
        }
    }
    
}

extension UpdateView {
    
    private func clickProperty(_ property: IconItem) {
        switch property {
        case .priority:
            showPriority.toggle()
            print("cliked \(showPriority)")
        default: return
        }
    }
    
    private func clickComplete() {
        taskViewModel.toggleCompleteTask(task: task)
        navigation.goBack()
    }
    
    private func clickDelete() {
        taskViewModel.deleteTask(task: task)
        navigation.goBack()
    }
    
    private func clickSave() {
        taskViewModel.updateTask(task: task, title: titleInput, details: detailsInput)
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
