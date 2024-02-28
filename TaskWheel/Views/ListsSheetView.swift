import SwiftUI

struct ListsSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
//    @State var selected: TaskListModel
//    
//    init() {
//        _selected = State(initialValue: taskViewModel.defaultTaskList)
//    }
//    
//    let sampleTaskLists = (1...4).map { "Task List \($0)" }
    private let color = ColorSettings()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 22) {
            ForEach(taskViewModel.taskLists) { taskList in
                view(taskList: taskList)
                    .onTapGesture {
                        click(taskList: taskList)
                    }
            }
            
            Divider()
                .padding(.horizontal, -10)
            
            HStack(spacing: 15) {
                Image(systemName: "plus")
                Text("Create new list")
                Spacer()
            }
        }
    }
    
    private func view(taskList: TaskListModel) -> some View {
        
        let highlight: Bool = false // selected == taskList
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? color.accent : color.text)
            
            Text(taskList.title)
            Spacer()
        }
    }
    
    private func click(taskList: TaskListModel) {
//        selected = taskList
        print("hi")
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples, TaskListModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    BottomTabView()
}
