import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State var titleInput: String
    @State var detailsInput: String
    @State var priorityInput: PriorityItem
    @State var dateInput: Date?
    
    @State private var showLists = false
    @State private var showPriority = false
    @State private var showSchedule = false
    
    @State private var barSelected: IconItem? = nil
    @State private var dateSelected: Date? = nil
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
        Text("hi")
//        VStack(alignment: .leading, spacing: 20) {
//            listTitleView()
//            
//            taskTitleView()
//            
//            propertyContainerView(task: task)
//            
//            Spacer()
//            
//            updateBarView()
//        }
//        .padding(.horizontal, 30)
//        .padding(.vertical, 15)
//        .font(.system(size: 20))
//        .foregroundStyle(color.text)
//        .background(color.background)
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                    saveGoBack()
//                }) {
//                    Image(systemName: "arrow.backward")
//                }
//                .padding([.horizontal])
//                .fontWeight(.semibold)
//            }
//        }
        
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
