import SwiftUI

struct UpdateView: View {
    let task: TaskModel

    @EnvironmentObject var navigation: NavigationCoordinator
    @State var titleInput: String = ""
    @State var detailsInput: String = ""

    private let color = ColorSettings()
    private let textDefault: String = "What now?"
    private let detailDefault: String = "Add details."
    private let cornerRadius: CGFloat = 25
    private let sizePadding: CGFloat = 30
    private let heightMaximum: CGFloat = 500
    private let maxLineLimit: Int = 20
    private let sizeFont: CGFloat = 20
    
//    init(task: TaskModel, titleInput: String = "") {
//        self.task = task
//        self.titleInput = titleInput
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: sizePadding - 10) {
            Text("current task list")
            
            Text(task.title)
                .font(.system(size: sizeFont * 2))
                .foregroundStyle(.primary)
                .strikethrough(task.isComplete ? true : false)
            
//            IconView(imageName: )
            IconView(imageName: "text.alignleft", input: task.details)
            IconView(imageName: "alarm", input: "date tbd")
            IconView(imageName: "tag", input: "priority tbd")
            Spacer()
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
                    IconView(imageName: "arrow.backward")
                }
                .padding([.horizontal])
                .fontWeight(.semibold)
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                HStack(spacing: sizePadding) {
                    Button(action: {
                        navigation.goBack()
                    }) {
                        IconView(imageName: "checkmark")
                    }
                    
                    Button(action: {
                        navigation.goBack()
                    }) {
                        IconView(imageName: "trash", input: "")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        navigation.goBack()
                    }) {
                        IconView(imageName: "square.and.arrow.down", input: "")
                    }
                }
                .padding([.horizontal])
                .fontWeight(.semibold)
                .foregroundStyle(color.accent)
            }
        }
        .foregroundStyle(color.text)
    }
}

struct IconView: View {
    
    let imageName: String
    let input: String
    
    private let sizePadding: CGFloat = 20
    
    init(imageName: String, input: String = "") {
        self.imageName = imageName
        self.input = input
    }
    
    var body: some View {
        HStack(spacing: sizePadding) {
            Image(systemName: imageName)
            
            if !input.isEmpty {
                Text(input)
                Spacer()
            }
        }
    }
}

#Preview("from main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
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
    let completed = TaskModel(title: "second task", isComplete: true, details: "i'm completed")
    return NavigationStack {
        UpdateView(task: completed)
    }
    .environmentObject(NavigationCoordinator())
}
