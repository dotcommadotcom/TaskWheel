import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    let task: TaskModel
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: Int
    
    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let taskListTitle: String = "current task list"
    private let bottomTabs: [IconItem] = [.complete, .delete, .save]
    
    init(task: TaskModel) {
        self.task = task
        _titleInput = State(initialValue: task.title)
        _detailsInput = State(initialValue: task.details)
        _priorityInput = State(initialValue: task.priority)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(taskListTitle)
            
            TextField(titleInput.isEmpty ? textDefault : titleInput, text: $titleInput, axis: .vertical)
                .lineLimit(5)
                .font(.system(size: 30))
                .strikethrough(task.isComplete ? true : false)
            
            PropertyContainerView(task: task)
            
            Spacer()
            
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
                    viewBottom(tab, isSpace: tab == bottomTabs.last, action: action)
                }
            }
            .foregroundStyle(color.accent)
            .font(.system(size: 25))
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
    
    private func PropertyContainerView(task: TaskModel) -> some View {
        VStack(spacing: 20) {
            viewProperty(.details, isEmpty: false, defaultText: "")
            
            viewProperty(.schedule, isEmpty: true, defaultText: "Set schedule")
            
            viewProperty(.priority, isEmpty: task.priority == 4, defaultText: "Set priority")
        }
    }
    
    private func viewProperty(_ property: IconItem, isEmpty: Bool, defaultText: String) -> some View {
        HStack(spacing: 13) {
            Image(systemName: property.text)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            if isEmpty {
                Text(defaultText)
                    .foregroundStyle(.gray.opacity(0.6))
            } else {
                TaskPropertyView(property)
            }
            
            Spacer()
        }
    }
    
    private func TaskPropertyView(_ property: IconItem) -> some View {
        switch property {
        case .details:
            return AnyView(
                TextField(detailsInput.isEmpty ? "Add details" : detailsInput, text: $detailsInput)
                    .foregroundStyle(detailsInput.isEmpty ? .gray : color.text)
                    .lineLimit(5)
            )
        case .priority:
            return AnyView(Text(PriorityItem(priorityInput).text))
        default:
            return AnyView(Text(property.text))
        }
    }
    
    private func viewBottom(_ tab: IconItem, isSpace: Bool, action: @escaping () -> Void) -> some View {
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
    
    private func clickComplete() {
        taskViewModel.toggleComplete(task: task)
        navigation.goBack()
    }
    
    private func clickDelete() {
        taskViewModel.delete(task: task)
        navigation.goBack()
    }
    
    private func clickSave() {
        taskViewModel.update(task: task, title: titleInput, details: detailsInput)
        navigation.goBack()
    }
}

#Preview("empty task", traits: .sizeThatFitsLayout) {
    let empty = TaskModel(title: "")
    return NavigationStack {
        UpdateView(task: empty)
    }
    .environmentObject(NavigationCoordinator())
}

#Preview("full task", traits: .sizeThatFitsLayout) {
    let full = TaskModel(title: "full task", isComplete: true, details: "i have details", priority: 2)
    return NavigationStack {
        UpdateView(task: full)
    }
    .environmentObject(NavigationCoordinator())
}
