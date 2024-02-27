import SwiftUI

enum PropertyItem: Hashable {
    case list, wheel
    
    var title: String {
        switch self {
        case .list: return "List"
        case .wheel: return "Wheel"
        }
    }
    
    var iconName: String {
        switch self {
        case .list: return "list.clipboard.fill"
        case .wheel: return "heart.fill"
        }
    }
}

struct UpdateView: View {

    @EnvironmentObject var navigation: NavigationCoordinator
    @State var titleInput: String = ""
    @State var detailsInput: String = ""

    let task: TaskModel
    
    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details."
    private let cornerRadius: CGFloat = 25
    private let sizePadding: CGFloat = 30
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: sizePadding - 10) {
            Text("current task list")
            
            Text(task.title)
                .font(.system(size: sizeFont * 2))
                .foregroundStyle(.primary)
                .strikethrough(task.isComplete ? true : false)
            
            PropertiesUpdateView(imageName: "text.alignleft", input: task.details, alternativeInput: "Add details", condition: !task.details.isEmpty)
            PropertiesUpdateView(imageName: !task.isComplete ? "square" : "checkmark.square", input: "Done", alternativeInput: "Incomplete", condition: task.isComplete)
            PropertiesUpdateView(imageName: "alarm", input: "Schedule", alternativeInput: "Set schedule", condition: false)
            PropertiesUpdateView(imageName: "tag", input: "Important", alternativeInput: "Add priority", condition: false)

            Spacer()
            BottomUpdateView(task: task)
        }
        .padding(.horizontal, sizePadding)
        .padding(.vertical, sizePadding / 2)
        .font(.system(size: sizeFont))
        .background(color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    navigation.goBack()
                }) {
                    PropertiesUpdateView(imageName: "arrow.backward")
                }
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
        }
        .foregroundStyle(color.text)
    }
}

struct PropertiesUpdateView: View {
    
    let imageName: String
    let input: String
    let alternativeInput: String
    let condition: Bool
    
    private let color = ColorSettings()
    private let sizePadding: CGFloat = 10
    private let sizeFont: CGFloat = 20
    
    init(imageName: String, input: String = "", alternativeInput: String = "", condition: Bool = false) {
        self.imageName = imageName
        self.input = input
        self.alternativeInput = alternativeInput
        self.condition = condition
    }
    
    var body: some View {
        HStack(spacing: sizePadding) {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 25, height: 25)
                Image(systemName: imageName)
            }
            
            if condition {
                Text(input)
            } else if !alternativeInput.isEmpty {
                Text(alternativeInput)
                    .foregroundStyle(.gray)
//                    .background(.yellow)
            }
            Spacer()
        }
//        .foregroundStyle(.jetSeasalt)
//        .background(.blue)
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
    let completed = TaskModel(title: "empty task")
    return NavigationStack {
        UpdateView(task: completed)
    }
    .environmentObject(NavigationCoordinator())
}

#Preview("incomplete task", traits: .sizeThatFitsLayout) {
    let incomplete = TaskModel(title: "first task", isComplete: false, details: "first task details")
    return NavigationStack {
        UpdateView(task: incomplete)
    }
    .environmentObject(NavigationCoordinator())
}

#Preview("completed task", traits: .sizeThatFitsLayout) {
    let completed = TaskModel(title: "second task", isComplete: true)
    return NavigationStack {
        UpdateView(task: completed)
    }
    .environmentObject(NavigationCoordinator())
}

