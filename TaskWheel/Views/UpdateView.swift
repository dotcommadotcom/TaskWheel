import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    let task: TaskModel
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: Int
    
    private let color = ColorSettings()
    private let taskListTitle: String = "current task list"
    
    init(task: TaskModel) {
        self.task = task
        _titleInput = State(initialValue: task.title)
        _detailsInput = State(initialValue: task.details)
        _priorityInput = State(initialValue: task.priority)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(taskListTitle)
            
            TextField(titleInput, text: $titleInput, axis: .vertical)
                .lineLimit(5)
                .font(.system(size: 30))
                .strikethrough(task.isComplete ? true : false)
            
            PropertyContainerView(task: task)
            
            Spacer()
            
            HStack(spacing: 30) {
                
                Button(action: {}) {
                    Image(systemName: "checkmark.square")
                }
                
                Button(action: clickDelete) {
                    Image(systemName: "trash")
                }
                
                Spacer()
                
                Button(action: clickSave) {
                    Image(systemName: "square.and.arrow.down")
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
            view(.details, isEmpty: task.details.isEmpty, defaultText: "Add details")
            
            view(.schedule, isEmpty: true, defaultText: "Set schedule")
            
            view(.priority, isEmpty: task.priority == 4, defaultText: "Set priority")
        }
    }
    
    private func view(_ property: IconItem, isEmpty: Bool, defaultText: String) -> some View {
        HStack(spacing: 13) {
            Image(systemName: property.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            if isEmpty {
                Text(defaultText)
                    .foregroundStyle(.gray)
            } else {
                viewProperty(property)
            }
            
            Spacer()
        }
    }
    
    private func viewProperty(_ property: IconItem) -> some View {
        switch property {
        case .details:
            return AnyView(TextField(detailsInput, text: $detailsInput)
                .lineLimit(5))
        case .priority:
            let priorityItem = PriorityItem(priorityInput)
            return AnyView(Text(priorityItem.text))
        default:
            return AnyView(Text(property.icon))
        }
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


#Preview("from main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview("empty task", traits: .sizeThatFitsLayout) {
    let empty = TaskModel(title: "empty task")
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
