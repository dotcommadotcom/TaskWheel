import SwiftUI

enum PropertyItem: Hashable {
    case details, complete, schedule, priority
    
    var emptyIcon: String {
        switch self {
        case .details: return "text.alignleft"
        case .complete: return "square"
        case .schedule: return "alarm"
        case .priority: return "tag"
        }
    }
    
    var fullIcon: String {
        switch self {
        case .complete: return "checkmark.square"
        default: return self.emptyIcon
        }
    }
    
    var emptyText: String {
        switch self {
        case .details: return "Add details"
        case .complete: return "Incomplete"
        case .schedule: return "Set schedule"
        case .priority: return "Add priority"
        }
    }
    
    var fullText: String {
        switch self {
        case .complete: return "All done"
        default: return "Should be hidden"
        }
    }
}

struct UpdateView: View {
    
    @EnvironmentObject var navigation: NavigationCoordinator
    @State var titleInput: String = ""
    @State var detailsInput: String = ""
    
    let task: TaskModel
    let properties: [PropertyItem] = [.details, .complete, .schedule, .priority]
    
    private let color = ColorSettings()
    private let taskListTitle: String = "current task list"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(taskListTitle)
            
            Text(task.title)
                .font(.system(size: 30))
                .strikethrough(task.isComplete ? true : false)
            
            ForEach(properties, id: \.self) { property in
                view(property: property, task: task)
            }

            Spacer()
            BottomUpdateView(task: task)
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
    
    private func view(property: PropertyItem, task: TaskModel) -> some View {
        
        let condition: Bool
        let shownProperty: String
        
        switch property {
        case .details:
            condition = !task.details.isEmpty
            shownProperty = task.details
        case .complete:
            condition = task.isComplete
            shownProperty = "All done"
        default:
            condition = false
            shownProperty = ""
        }
        
        return HStack(spacing: 13) {
            Image(systemName: condition ? property.fullIcon : property.emptyIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            if condition {
                Text(shownProperty)
            } else {
                Text(property.emptyText)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

struct BottomUpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    let task: TaskModel
    
    private let color = ColorSettings()
    
    var body: some View {
        HStack {
            Button(action: {
                navigation.goBack()
                taskViewModel.deleteTask(task)
            }) {
                Image(systemName: "trash")
            }
            
            Spacer()
            
            Button(action: {
                navigation.goBack()
                taskViewModel.updateTask(task)
            }) {
                Image(systemName: "square.and.arrow.down")
            }
        }
        .foregroundStyle(color.accent)
        .font(.system(size: 25))
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
    let full = TaskModel(title: "full task", isComplete: true, details: "i have details")
    return NavigationStack {
        UpdateView(task: full)
    }
    .environmentObject(NavigationCoordinator())
}
